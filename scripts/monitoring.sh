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

# Function to start monitoring stack
start_monitoring() {
    log_info "Starting monitoring stack..."
    
    cd monitoring
    docker-compose -f docker-compose.monitoring.yml up -d
    cd ..
    
    log_info "Waiting for services to be ready..."
    sleep 15
    
    # Check if services are healthy
    if curl -f http://localhost:9090 > /dev/null 2>&1; then
        log_info "✅ Prometheus is running"
    else
        log_error "❌ Prometheus failed to start"
    fi
    
    if curl -f http://localhost:3001 > /dev/null 2>&1; then
        log_info "✅ Grafana is running"
    else
        log_error "❌ Grafana failed to start"
    fi
    
    log_info "📊 Monitoring stack started!"
    echo ""
    echo "🔗 Access URLs:"
    echo "  Prometheus: http://localhost:9090"
    echo "  Grafana: http://localhost:3001 (admin/admin123)"
    echo "  AlertManager: http://localhost:9093"
    echo "  Node Exporter: http://localhost:9100"
    echo "  cAdvisor: http://localhost:8080"
}

# Function to stop monitoring stack
stop_monitoring() {
    log_info "Stopping monitoring stack..."
    cd monitoring
    docker-compose -f docker-compose.monitoring.yml down
    cd ..
    log_info "✅ Monitoring stack stopped"
}

# Function to restart monitoring
restart_monitoring() {
    stop_monitoring
    start_monitoring
}

# Function to show logs
logs() {
    local service=${1:-prometheus}
    cd monitoring
    docker-compose -f docker-compose.monitoring.yml logs -f "$service"
    cd ..
}

# Function to show status
status() {
    echo "=== Monitoring Stack Status ==="
    cd monitoring
    docker-compose -f docker-compose.monitoring.yml ps
    cd ..
    echo ""
    echo "=== Service Health ==="
    
    services=(
        "Prometheus:http://localhost:9090"
        "Grafana:http://localhost:3001"
        "AlertManager:http://localhost:9093"
        "Node Exporter:http://localhost:9100/metrics"
        "cAdvisor:http://localhost:8080"
    )
    
    for service in "${services[@]}"; do
        name=$(echo "$service" | cut -d: -f1)
        url=$(echo "$service" | cut -d: -f2-3)
        
        if curl -f "$url" > /dev/null 2>&1; then
            echo "✅ $name: Healthy"
        else
            echo "❌ $name: Not responding"
        fi
    done
}

# Function to start full stack (app + monitoring)
start_full() {
    log_info "Starting full stack (application + monitoring)..."
    
    # Start monitoring first
    start_monitoring
    
    # Start application
    log_info "Starting application..."
    docker-compose up -d
    
    log_info "🚀 Full stack started!"
    echo ""
    echo "📱 Application: http://localhost:3000"
    echo "📊 Monitoring: http://localhost:3001"
}

# Main function
case "$1" in
    start)
        start_monitoring
        ;;
    stop)
        stop_monitoring
        ;;
    restart)
        restart_monitoring
        ;;
    logs)
        logs "$2"
        ;;
    status)
        status
        ;;
    full)
        start_full
        ;;
    *)
        echo "Usage: $0 {start|stop|restart|logs [service]|status|full}"
        echo ""
        echo "Commands:"
        echo "  start   - Start monitoring stack"
        echo "  stop    - Stop monitoring stack"  
        echo "  restart - Restart monitoring stack"
        echo "  logs    - Show logs for service (default: prometheus)"
        echo "  status  - Show status of all services"
        echo "  full    - Start application + monitoring"
        echo ""
        echo "Examples:"
        echo "  $0 start"
        echo "  $0 logs grafana"
        echo "  $0 full"
        exit 1
        ;;
esac
