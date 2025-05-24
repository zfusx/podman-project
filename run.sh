#!/bin/bash

# Simple FastAPI with Podman - Build and Run Script

set -e

IMAGE_NAME="fastapi-podman-app"
CONTAINER_NAME="fastapi-container"
PORT=8000

echo "🐍 Building FastAPI application with Podman..."

# Build the image
echo "Building image: $IMAGE_NAME"
podman build -t $IMAGE_NAME .

echo "✅ Image built successfully!"

# Stop and remove existing container if it exists
echo "Checking for existing container..."
if podman ps -a --format "{{.Names}}" | grep -q "^${CONTAINER_NAME}$"; then
    echo "Stopping and removing existing container: $CONTAINER_NAME"
    podman stop $CONTAINER_NAME || true
    podman rm $CONTAINER_NAME || true
fi

# Run the container
echo "🚀 Running container: $CONTAINER_NAME"
podman run -d \
    --name $CONTAINER_NAME \
    -p $PORT:8000 \
    $IMAGE_NAME

echo "✅ Container is running!"
echo "📡 API is available at: http://localhost:$PORT"
echo "📚 API docs available at: http://localhost:$PORT/docs"
echo ""
echo "To stop the container, run: podman stop $CONTAINER_NAME"
echo "To view logs, run: podman logs $CONTAINER_NAME"
echo "To follow logs, run: podman logs -f $CONTAINER_NAME"