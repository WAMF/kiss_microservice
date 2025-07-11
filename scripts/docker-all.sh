#!/bin/bash

set -e

echo "🚀 Todo API Docker - Build, Run, and Test"
echo "========================================"
echo ""

# Build the image
echo "Step 1: Building Docker image..."
./scripts/docker-build.sh

echo ""
echo "Step 2: Running Docker container..."
./scripts/docker-run.sh

echo ""
echo "Step 3: Waiting for service to start..."
sleep 5

echo ""
echo "Step 4: Testing the service..."
./scripts/docker-test.sh

echo ""
echo "🎉 All done! Your Todo API is running and tested."
echo ""
echo "🌐 API URL: http://localhost:8080"
echo "📖 API Documentation: http://localhost:8080/"
echo ""
echo "To stop the service:"
echo "  docker stop todo-api-container"