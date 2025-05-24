#!/bin/bash

# FastAPI Development with Podman - Mount Volume Script

set -e

IMAGE_NAME="fastapi-podman-dev"
CONTAINER_NAME="fastapi-dev-container"
PORT=8000
CURRENT_DIR=$(pwd)

echo "🐍 Building FastAPI development image with Podman..."

# Build the development image
echo "Building development image: $IMAGE_NAME"
podman build -f Dockerfile.dev -t $IMAGE_NAME .

echo "✅ Development image built successfully!"

# Stop and remove existing container if it exists
echo "Checking for existing development container..."
if podman ps -a --format "{{.Names}}" | grep -q "^${CONTAINER_NAME}$"; then
    echo "Stopping and removing existing container: $CONTAINER_NAME"
    podman stop $CONTAINER_NAME || true
    podman rm $CONTAINER_NAME || true
fi

# Run the container with volume mount
echo "🚀 Running development container with volume mount: $CONTAINER_NAME"
podman run -d \
    --name $CONTAINER_NAME \
    -p $PORT:8000 \
    -v "$CURRENT_DIR:/app:Z" \
    $IMAGE_NAME

echo "✅ Development container is running with live reload!"
echo "📁 Current directory ($CURRENT_DIR) is mounted to /app in container"
echo "📡 API is available at: http://localhost:$PORT"
echo "📚 API docs available at: http://localhost:$PORT/docs"
echo "🔄 Auto-reload is enabled - code changes will be reflected automatically"
echo ""
echo "Useful commands:"
echo "  Stop container:    podman stop $CONTAINER_NAME"
echo "  View logs:         podman logs $CONTAINER_NAME"
echo "  Follow logs:       podman logs -f $CONTAINER_NAME"
echo "  Execute shell:     podman exec -it $CONTAINER_NAME /bin/bash"