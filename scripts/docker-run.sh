#!/bin/bash

set -e

IMAGE_NAME="todo-api"
TAG="${1:-latest}"
CONTAINER_NAME="todo-api-container"
PORT="${2:-8080}"

echo "🐳 Running Todo API Docker container..."

if docker ps -q -f name="${CONTAINER_NAME}" | grep -q .; then
    echo "🛑 Stopping existing container..."
    docker stop "${CONTAINER_NAME}"
fi

if docker ps -aq -f name="${CONTAINER_NAME}" | grep -q .; then
    echo "🗑️  Removing existing container..."
    docker rm "${CONTAINER_NAME}"
fi

echo "🚀 Starting new container..."
docker run -d \
    --name "${CONTAINER_NAME}" \
    -p "${PORT}:8080" \
    --restart unless-stopped \
    "${IMAGE_NAME}:${TAG}"

echo "✅ Container started successfully!"
echo "📋 Container: ${CONTAINER_NAME}"
echo "🌐 URL: http://localhost:${PORT}"
echo "📊 Status: $(docker ps --format 'table {{.Status}}' -f name="${CONTAINER_NAME}" | tail -n1)"
echo ""
echo "📝 Useful commands:"
echo "  docker logs ${CONTAINER_NAME}           # View logs"
echo "  docker logs -f ${CONTAINER_NAME}        # Follow logs"
echo "  docker stop ${CONTAINER_NAME}           # Stop container"
echo "  docker restart ${CONTAINER_NAME}        # Restart container"
echo ""
echo "🧪 To test the service:"
echo "  ./scripts/docker-test.sh"