#!/bin/bash

# FastAPI Development Management Script

set -e

CONTAINER_NAME="fastapi-dev-container"
IMAGE_NAME="fastapi-podman-dev"

function show_usage() {
    echo "Usage: $0 {start|stop|restart|logs|shell|clean}"
    echo ""
    echo "Commands:"
    echo "  start    - Start the development container"
    echo "  stop     - Stop the development container"
    echo "  restart  - Restart the development container"
    echo "  logs     - Show container logs"
    echo "  shell    - Open shell in the container"
    echo "  clean    - Stop and remove container and image"
    echo ""
}

function start_container() {
    echo "🚀 Starting development container..."
    ./run-dev.sh
}

function stop_container() {
    echo "🛑 Stopping development container..."
    if podman ps --format "{{.Names}}" | grep -q "^${CONTAINER_NAME}$"; then
        podman stop $CONTAINER_NAME
        echo "✅ Container stopped"
    else
        echo "ℹ️  Container is not running"
    fi
}

function restart_container() {
    echo "🔄 Restarting development container..."
    stop_container
    sleep 2
    start_container
}

function show_logs() {
    echo "📋 Showing container logs..."
    if podman ps -a --format "{{.Names}}" | grep -q "^${CONTAINER_NAME}$"; then
        podman logs -f $CONTAINER_NAME
    else
        echo "❌ Container does not exist"
    fi
}

function open_shell() {
    echo "🐚 Opening shell in container..."
    if podman ps --format "{{.Names}}" | grep -q "^${CONTAINER_NAME}$"; then
        podman exec -it $CONTAINER_NAME /bin/bash
    else
        echo "❌ Container is not running"
    fi
}

function clean_up() {
    echo "🧹 Cleaning up development environment..."
    
    # Stop container if running
    if podman ps --format "{{.Names}}" | grep -q "^${CONTAINER_NAME}$"; then
        echo "Stopping container..."
        podman stop $CONTAINER_NAME
    fi
    
    # Remove container if exists
    if podman ps -a --format "{{.Names}}" | grep -q "^${CONTAINER_NAME}$"; then
        echo "Removing container..."
        podman rm $CONTAINER_NAME
    fi
    
    # Remove image if exists
    if podman images --format "{{.Repository}}" | grep -q "^${IMAGE_NAME}$"; then
        echo "Removing image..."
        podman rmi $IMAGE_NAME
    fi
    
    echo "✅ Cleanup completed"
}

# Main script logic
case "${1:-}" in
    start)
        start_container
        ;;
    stop)
        stop_container
        ;;
    restart)
        restart_container
        ;;
    logs)
        show_logs
        ;;
    shell)
        open_shell
        ;;
    clean)
        clean_up
        ;;
    *)
        show_usage
        exit 1
        ;;
esac