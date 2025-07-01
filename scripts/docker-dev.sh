#!/bin/bash

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to start development environment
start_dev() {
    log_info "Starting development environment..."
    docker-compose up -d
    
    log_info "Waiting for services to be ready..."
    sleep 10
    
    # Check if webapp is healthy
    if curl -f http://localhost:3000/health > /dev/null 2>&1; then
        log_info "✅ Application is running successfully!"
        echo ""
        echo "🌐 Application: http://localhost:3000"
        echo "❤️  Health Check: http://localhost:3000/health"
        echo "📊 Metrics: http://localhost:3000/metrics"
        echo ""
        echo "📝 To view logs: docker-compose logs -f webapp"
        echo "🛑 To stop: docker-compose down"
    else
        log_error "❌ Application failed to start properly"
        docker-compose logs webapp
    fi
}

# Function to stop development environment
stop_dev() {
    log_info "Stopping development environment..."
    docker-compose down
    log_info "✅ Environment stopped"
}

# Function to rebuild and restart
rebuild() {
    log_info "Rebuilding and restarting application..."
    docker-compose down
    docker-compose build --no-cache webapp
    docker-compose up -d
    log_info "✅ Application rebuilt and restarted"
}

# Function to show logs
logs() {
    docker-compose logs -f webapp
}

# Function to show status
status() {
    echo "=== Docker Images ==="
    docker images | grep cicd-webapp-nodejs
    echo ""
    echo "=== Running Containers ==="
    docker-compose ps
    echo ""
    echo "=== Health Check ==="
    curl -s http://localhost:3000/health | jq . || echo "Application not responding"
}

# Function to clean up
cleanup() {
    log_warn "Cleaning up Docker resources..."
    docker-compose down -v
    docker image prune -f
    docker volume prune -f
    log_info "✅ Cleanup completed"
}

# Main function
case "$1" in
    start)
        start_dev
        ;;
    stop)
        stop_dev
        ;;
    restart)
        stop_dev
        start_dev
        ;;
    rebuild)
        rebuild
        ;;
    logs)
        logs
        ;;
    status)
        status
        ;;
    clean)
        cleanup
        ;;
    *)
        echo "Usage: $0 {start|stop|restart|rebuild|logs|status|clean}"
        echo ""
        echo "Commands:"
        echo "  start   - Start the development environment"
        echo "  stop    - Stop the development environment"
        echo "  restart - Restart the development environment"
        echo "  rebuild - Rebuild and restart the application"
        echo "  logs    - Show application logs"
        echo "  status  - Show current status"
        echo "  clean   - Clean up Docker resources"
        exit 1
        ;;
esac
