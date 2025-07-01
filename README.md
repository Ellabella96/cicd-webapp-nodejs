# CI/CD WebApp with Node.js

A comprehensive DevOps project demonstrating modern deployment practices with containerization, CI/CD pipelines, and monitoring.

## 🚀 Features

- **Node.js Web Application**: Express.js app with health checks and metrics
- **Containerization**: Docker containers with multi-stage builds
- **CI/CD Pipeline**: GitHub Actions for automated testing and deployment
- **Monitoring**: Prometheus metrics and Grafana dashboards
- **Infrastructure as Code**: Terraform for cloud resource management
- **Security**: Automated security scanning and best practices

## 🛠️ Tech Stack

- **Backend**: Node.js, Express.js
- **Containerization**: Docker, Docker Compose
- **CI/CD**: GitHub Actions
- **Monitoring**: Prometheus, Grafana, AlertManager
- **Infrastructure**: Terraform, AWS
- **Security**: ESLint, npm audit, Trivy

## 🚀 Quick Start

### Prerequisites
- Docker and Docker Compose
- Node.js 18+ (for local development)
- Git

### Local Development

```bash
## Clone the repository
git clone https://github.com/ellabella96/cicd-webapp-nodejs.git
cd cicd-webapp-nodejs

## Option 1: Run with Docker (Recommended)
docker-compose up -d

## Option 2: Run locally
cd app
npm install
npm start

## Access the Application

Web App: http://localhost:3000
Health Check: http://localhost:3000/health
Metrics: http://localhost:3000/metrics

# 📊 Monitoring
Start Monitoring Stack
bash# Start Prometheus and Grafana
docker-compose -f monitoring/docker-compose.monitoring.yml up -d
Access Monitoring

Prometheus: http://localhost:9090
Grafana: http://localhost:3001 (admin/admin)

# 🚀 Deployment
Manual Deployment
bash# Build and run with Docker
docker-compose up -d

# Deploy with Terraform (when ready)
cd infrastructure
terraform init
terraform plan
terraform apply

Automated Deployment
Push to main branch triggers automatic deployment via GitHub Actions.
🧪 Testing
bashcd app

# Run tests
npm test

# Run linting
npm run lint

# Security audit
npm audit
📈 Metrics
The application exposes the following metrics:

HTTP request duration and count
System metrics (CPU, memory)
Custom business metrics
Container health status

🔧 Configuration
Environment Variables
bashPORT=3000                    # Application port
NODE_ENV=production         # Environment
PROMETHEUS_ENDPOINT=/metrics # Metrics endpoint
Docker Commands
bash# Development
./scripts/docker-dev.sh start

# Production
docker-compose -f docker-compose.prod.yml up -d

# View logs
docker-compose logs -f webapp
