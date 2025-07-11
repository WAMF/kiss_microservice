#!/bin/bash

set -e

BASE_URL="${1:-http://localhost:8080}"
CONTAINER_NAME="todo-api-container"

echo "🚀 Todo API Demo - Learning Journey"
echo "=================================="
echo ""

# Color codes for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Wait for service to be ready
echo "🌐 Waiting for service at ${BASE_URL}..."
max_attempts=30
attempt=1

while [ $attempt -le $max_attempts ]; do
    if curl -s "$BASE_URL/" > /dev/null 2>&1; then
        break
    fi
    echo "   Attempt $attempt/$max_attempts..."
    sleep 2
    attempt=$((attempt + 1))
done

if [ $attempt -gt $max_attempts ]; then
    echo "❌ Service not ready after $max_attempts attempts"
    exit 1
fi

echo -e "${GREEN}✅ Service is ready!${NC}"
echo ""

# Create learning journey todos
echo "📝 Creating learning journey..."
todos=(
    '{"title":"🎯 Learn Dart","description":"Master Dart fundamentals - syntax, OOP, async programming"}'
    '{"title":"🏗️ Create a Dart microservice","description":"Build a scalable microservice using clean architecture"}'
    '{"title":"📱 Learn Flutter","description":"Develop cross-platform mobile apps with Flutter"}'
    '{"title":"💰 Make money","description":"Monetize your Dart/Flutter skills through freelancing or products"}'
)

todo_ids=()
for i in "${!todos[@]}"; do
    response=$(curl -s -X POST "$BASE_URL/todos" \
        -H "Content-Type: application/json" \
        -d "${todos[$i]}" \
        -w "\n%{http_code}")
    
    status_code=$(echo "$response" | tail -n1)
    body=$(echo "$response" | sed '$d')
    
    if [ "$status_code" = "201" ]; then
        todo_id=$(echo "$body" | grep -o '"id":"[^"]*"' | cut -d'"' -f4)
        todo_ids+=("$todo_id")
        title=$(echo "${todos[$i]}" | grep -o '"title":"[^"]*"' | cut -d'"' -f4)
        echo "   ✏️  Created: $title"
    fi
done
echo ""

# Show the todos
echo "📋 Your learning journey:"
response=$(curl -s "$BASE_URL/todos")
echo "$response" | grep -o '"title":"[^"]*"' | cut -d'"' -f4 | sed 's/^/   ☐ /'
echo ""

# Complete each todo
echo "✅ Completing the journey..."
for i in "${!todo_ids[@]}"; do
    todo_id="${todo_ids[$i]}"
    title=$(echo "${todos[$i]}" | grep -o '"title":"[^"]*"' | cut -d'"' -f4)
    
    curl -s -X PATCH "$BASE_URL/todos/$todo_id" \
        -H "Content-Type: application/json" \
        -d '{"completed":true}' > /dev/null
    
    echo "   ✅ $title"
    sleep 1
done
echo ""

# Show final statistics
echo "📊 Final statistics:"
stats=$(curl -s "$BASE_URL/todos/stats")
total=$(echo "$stats" | grep -o '"total":[0-9]*' | cut -d':' -f2)
completed=$(echo "$stats" | grep -o '"completed":[0-9]*' | cut -d':' -f2)
echo "   📈 Total todos: $total"
echo "   🎯 Completed: $completed"
echo ""

echo -e "${GREEN}🎉 Learning journey completed!${NC}"
echo -e "${BLUE}💡 Journey: Learn Dart → Create Microservice → Learn Flutter → Make Money${NC}"
echo ""
echo "🌐 API running at: $BASE_URL"
echo "🛑 To stop: docker stop $CONTAINER_NAME"