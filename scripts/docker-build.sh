#!/bin/bash

set -e

echo "🐳 Building Todo API Docker image..."

IMAGE_NAME="todo-api"
TAG="${1:-latest}"
FULL_IMAGE_NAME="${IMAGE_NAME}:${TAG}"

echo "📦 Building image: ${FULL_IMAGE_NAME}"
docker build -t "${FULL_IMAGE_NAME}" .

echo "✅ Build complete!"
echo "📋 Image: ${FULL_IMAGE_NAME}"
echo ""
echo "🚀 To run the container:"
echo "  ./scripts/docker-run.sh"
echo ""
echo "🧪 To test the service:"
echo "  ./scripts/docker-test.sh"