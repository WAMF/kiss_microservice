#!/bin/bash

set -e

BASE_URL="${1:-http://localhost:8080}"
CONTAINER_NAME="todo-api-container"

echo "🧪 Testing Todo API Docker service..."
echo "🌐 Base URL: ${BASE_URL}"
echo ""

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    local status=$1
    local message=$2
    if [ "$status" = "PASS" ]; then
        echo -e "${GREEN}✅ PASS${NC}: $message"
    elif [ "$status" = "FAIL" ]; then
        echo -e "${RED}❌ FAIL${NC}: $message"
        exit 1
    elif [ "$status" = "INFO" ]; then
        echo -e "${BLUE}ℹ️  INFO${NC}: $message"
    elif [ "$status" = "WARN" ]; then
        echo -e "${YELLOW}⚠️  WARN${NC}: $message"
    fi
}

# Function to make HTTP requests
http_request() {
    local method=$1
    local url=$2
    local data=$3
    
    if [ -n "$data" ]; then
        curl -s -X "$method" "$url" \
            -H "Content-Type: application/json" \
            -d "$data" \
            -w "\n%{http_code}"
    else
        curl -s -X "$method" "$url" \
            -w "\n%{http_code}"
    fi
}

# Function to extract status code (last line)
get_status_code() {
    echo "$1" | tail -n1
}

# Function to extract body (all but last line)
get_body() {
    echo "$1" | sed '$d'
}

# Wait for service to be ready
print_status "INFO" "Waiting for service to be ready..."
max_attempts=30
attempt=1

while [ $attempt -le $max_attempts ]; do
    if curl -s "$BASE_URL/" > /dev/null 2>&1; then
        break
    fi
    print_status "INFO" "Attempt $attempt/$max_attempts - waiting for service..."
    sleep 2
    attempt=$((attempt + 1))
done

if [ $attempt -gt $max_attempts ]; then
    print_status "FAIL" "Service not ready after $max_attempts attempts"
fi

print_status "PASS" "Service is ready"
echo ""

# Test 1: Root endpoint
print_status "INFO" "Test 1: Root endpoint"
response=$(http_request "GET" "$BASE_URL/")
status_code=$(get_status_code "$response")
body=$(get_body "$response")

if [ "$status_code" = "200" ]; then
    print_status "PASS" "Root endpoint returns 200"
    if echo "$body" | grep -q "Todo Microservice API"; then
        print_status "PASS" "Root endpoint contains API information"
    else
        print_status "FAIL" "Root endpoint missing API information"
    fi
else
    print_status "FAIL" "Root endpoint returned status $status_code"
fi
echo ""

# Test 2: Get all todos (should be empty initially)
print_status "INFO" "Test 2: Get all todos"
response=$(http_request "GET" "$BASE_URL/todos")
status_code=$(get_status_code "$response")
body=$(get_body "$response")

if [ "$status_code" = "200" ]; then
    print_status "PASS" "GET /todos returns 200"
    if echo "$body" | grep -q '"total":0'; then
        print_status "PASS" "Initial todos list is empty"
    else
        print_status "WARN" "Todos list is not empty (may be from previous tests)"
    fi
else
    print_status "FAIL" "GET /todos returned status $status_code"
fi
echo ""

# Test 3: Create a todo
print_status "INFO" "Test 3: Create a todo"
todo_data='{"title":"Test Todo","description":"Testing Docker service"}'
response=$(http_request "POST" "$BASE_URL/todos" "$todo_data")
status_code=$(get_status_code "$response")
body=$(get_body "$response")

if [ "$status_code" = "201" ]; then
    print_status "PASS" "POST /todos returns 201"
    todo_id=$(echo "$body" | grep -o '"id":"[^"]*"' | cut -d'"' -f4)
    if [ -n "$todo_id" ]; then
        print_status "PASS" "Created todo has ID: $todo_id"
    else
        print_status "FAIL" "Created todo missing ID"
    fi
else
    print_status "FAIL" "POST /todos returned status $status_code"
fi
echo ""

# Test 4: Get the created todo
if [ -n "$todo_id" ]; then
    print_status "INFO" "Test 4: Get created todo"
    response=$(http_request "GET" "$BASE_URL/todos/$todo_id")
    status_code=$(get_status_code "$response")
    body=$(get_body "$response")

    if [ "$status_code" = "200" ]; then
        print_status "PASS" "GET /todos/{id} returns 200"
        if echo "$body" | grep -q "Test Todo"; then
            print_status "PASS" "Retrieved todo contains correct title"
        else
            print_status "FAIL" "Retrieved todo missing correct title"
        fi
    else
        print_status "FAIL" "GET /todos/{id} returned status $status_code"
    fi
    echo ""
fi

# Test 5: Update the todo
if [ -n "$todo_id" ]; then
    print_status "INFO" "Test 5: Update todo"
    update_data='{"completed":true}'
    response=$(http_request "PATCH" "$BASE_URL/todos/$todo_id" "$update_data")
    status_code=$(get_status_code "$response")
    body=$(get_body "$response")

    if [ "$status_code" = "200" ]; then
        print_status "PASS" "PATCH /todos/{id} returns 200"
        if echo "$body" | grep -q '"completed":true'; then
            print_status "PASS" "Todo successfully marked as completed"
        else
            print_status "FAIL" "Todo not marked as completed"
        fi
    else
        print_status "FAIL" "PATCH /todos/{id} returned status $status_code"
    fi
    echo ""
fi

# Test 6: Get todo statistics
print_status "INFO" "Test 6: Get todo statistics"
response=$(http_request "GET" "$BASE_URL/todos/stats")
status_code=$(get_status_code "$response")
body=$(get_body "$response")

if [ "$status_code" = "200" ]; then
    print_status "PASS" "GET /todos/stats returns 200"
    if echo "$body" | grep -q '"total":[0-9]'; then
        print_status "PASS" "Statistics contains total count"
    else
        print_status "FAIL" "Statistics missing total count"
    fi
else
    print_status "FAIL" "GET /todos/stats returned status $status_code"
fi
echo ""

# Test 7: Search todos
print_status "INFO" "Test 7: Search todos"
response=$(http_request "GET" "$BASE_URL/todos/search/Test")
status_code=$(get_status_code "$response")
body=$(get_body "$response")

if [ "$status_code" = "200" ]; then
    print_status "PASS" "GET /todos/search/{query} returns 200"
else
    print_status "FAIL" "GET /todos/search/{query} returned status $status_code"
fi
echo ""

# Test 8: Test error handling
print_status "INFO" "Test 8: Error handling"
response=$(http_request "GET" "$BASE_URL/todos/non-existent-id")
status_code=$(get_status_code "$response")

if [ "$status_code" = "404" ]; then
    print_status "PASS" "Non-existent todo returns 404"
else
    print_status "FAIL" "Non-existent todo returned status $status_code (expected 404)"
fi
echo ""

# Test 9: Delete the todo
if [ -n "$todo_id" ]; then
    print_status "INFO" "Test 9: Delete todo"
    response=$(http_request "DELETE" "$BASE_URL/todos/$todo_id")
    status_code=$(get_status_code "$response")

    if [ "$status_code" = "200" ]; then
        print_status "PASS" "DELETE /todos/{id} returns 200"
        
        # Verify todo is deleted
        response=$(http_request "GET" "$BASE_URL/todos/$todo_id")
        status_code=$(get_status_code "$response")
        
        if [ "$status_code" = "404" ]; then
            print_status "PASS" "Deleted todo no longer exists"
        else
            print_status "FAIL" "Deleted todo still exists"
        fi
    else
        print_status "FAIL" "DELETE /todos/{id} returned status $status_code"
    fi
    echo ""
fi

# Summary
echo "🎉 All tests completed!"
echo ""

# Display container info if running
if docker ps -q -f name="${CONTAINER_NAME}" | grep -q .; then
    print_status "INFO" "Container status:"
    docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" -f name="${CONTAINER_NAME}"
    echo ""
    print_status "INFO" "To view logs: docker logs ${CONTAINER_NAME}"
    print_status "INFO" "To stop container: docker stop ${CONTAINER_NAME}"
else
    print_status "WARN" "Container ${CONTAINER_NAME} is not running"
fi