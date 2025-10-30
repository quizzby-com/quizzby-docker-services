# 🚀 Quizzby Docker Services

Complete Docker stack for the Quizzby platform with monitoring, database management, container orchestration, and code quality analysis.

## 📋 Services Overview

| Service | Purpose | Port | URL |
|---------|---------|------|-----|
| **Traefik** | Reverse Proxy & Load Balancer | 80, 443, 8080 | http://traefik.localhost:8080 |
| **Grafana** | Monitoring & Observability | 3000 | http://grafana.localhost |
| **NocoDB** | No-code Database Platform | 8080 | http://nocodb.localhost |
| **Portainer** | Docker Management UI | 9000 | http://portainer.localhost |
| **SonarQube** | Code Quality Analysis | 9000 | http://sonarqube.localhost |

## 🚀 Quick Start

### 1. Prerequisites
```bash
# Ensure Docker and Docker Compose are installed
docker --version
docker-compose --version

# Set system limits for SonarQube (Linux/macOS)
sudo sysctl -w vm.max_map_count=524288
sudo sysctl -w fs.file-max=131072
```

### 2. Configuration
```bash
# Copy environment file
cp .env.example .env

# Edit with your secure passwords
nano .env
```

### 3. Start All Services
```bash
# Start the complete stack
docker-compose up -d

# View logs
docker-compose logs -f

# Check status
docker-compose ps
```

### 4. Access Services
Add to your `/etc/hosts` file (for localhost domains):
```
127.0.0.1 traefik.localhost
127.0.0.1 grafana.localhost
127.0.0.1 nocodb.localhost
127.0.0.1 portainer.localhost
127.0.0.1 sonarqube.localhost
```

## 🔧 Individual Service Management

### Start Specific Services
```bash
# Start only monitoring stack
docker-compose up -d grafana

# Start only database services
docker-compose up -d nocodb nocodb-postgres

# Start only development tools
docker-compose up -d portainer sonarqube sonarqube-postgres
```

### Service-Specific Commands
```bash
# Grafana
docker-compose exec grafana grafana-cli plugins list

# NocoDB
docker-compose exec nocodb-postgres psql -U nocodb -d nocodb

# SonarQube
docker-compose exec sonarqube-postgres pg_dump -U sonarqube sonarqube > backup.sql

# Portainer (reset admin password)
docker-compose exec portainer /portainer --admin-password='$2y$10$...'
```

## 📊 Service Details

### 🔍 Traefik (Reverse Proxy)
- **Dashboard**: http://traefik.localhost:8080
- **Features**: Automatic service discovery, SSL termination, load balancing
- **Config**: Auto-configured via Docker labels

### 📈 Grafana (Monitoring)
- **URL**: http://grafana.localhost
- **Default Login**: admin / [from .env file]
- **Features**: Dashboards, alerting, data visualization
- **Data**: Persistent in Docker volume

### 🗄️ NocoDB (Database UI)
- **URL**: http://nocodb.localhost
- **Default Login**: [from .env file]
- **Database**: PostgreSQL backend
- **Features**: No-code database, API generation, collaboration

### 🐳 Portainer (Docker Management)
- **URL**: http://portainer.localhost
- **Features**: Container management, image registry, stack deployment
- **Access**: Docker socket mounted for full control

### 🔍 SonarQube (Code Quality)
- **URL**: http://sonarqube.localhost
- **Default Login**: admin / admin (change immediately)
- **Database**: PostgreSQL with optimized settings
- **Features**: Code analysis, security scanning, technical debt tracking

## 🛡️ Security Configuration

### Default Passwords
⚠️ **Change all default passwords in `.env` file before production use!**

### Network Security
- All services run on isolated `quizzby-network`
- External access only through Traefik reverse proxy
- Database services not directly exposed

### SSL/TLS (Production)
```bash
# Enable HTTPS in production
# Uncomment SSL settings in .env file
# Update domain names to real domains
# Traefik will automatically obtain Let's Encrypt certificates
```

## 🔄 Backup & Restore

### Backup All Data
```bash
#!/bin/bash
# Create backup directory
mkdir -p backups/$(date +%Y%m%d)

# Backup all volumes
docker run --rm -v quizzby-docker-services_grafana-data:/data -v $(pwd)/backups/$(date +%Y%m%d):/backup alpine tar czf /backup/grafana.tar.gz -C /data .
docker run --rm -v quizzby-docker-services_nocodb-data:/data -v $(pwd)/backups/$(date +%Y%m%d):/backup alpine tar czf /backup/nocodb.tar.gz -C /data .
docker run --rm -v quizzby-docker-services_portainer-data:/data -v $(pwd)/backups/$(date +%Y%m%d):/backup alpine tar czf /backup/portainer.tar.gz -C /data .

# Backup databases
docker-compose exec nocodb-postgres pg_dump -U nocodb nocodb > backups/$(date +%Y%m%d)/nocodb.sql
docker-compose exec sonarqube-postgres pg_dump -U sonarqube sonarqube > backups/$(date +%Y%m%d)/sonarqube.sql
```

### Restore Data
```bash
# Restore volume data
docker run --rm -v quizzby-docker-services_grafana-data:/data -v $(pwd)/backups/YYYYMMDD:/backup alpine tar xzf /backup/grafana.tar.gz -C /data

# Restore databases
docker-compose exec -T nocodb-postgres psql -U nocodb -d nocodb < backups/YYYYMMDD/nocodb.sql
```

## 🚧 Troubleshooting

### Common Issues

#### Services Not Starting
```bash
# Check logs
docker-compose logs service-name

# Check system resources
docker system df
docker system prune

# Restart specific service
docker-compose restart service-name
```

#### Permission Issues
```bash
# Fix volume permissions
sudo chown -R $USER:$USER /var/lib/docker/volumes/
```

#### SonarQube Memory Issues
```bash
# Increase memory limits
echo 'vm.max_map_count=524288' | sudo tee -a /etc/sysctl.conf
sudo sysctl -p
```

#### DNS Resolution
```bash
# Add to /etc/hosts or use real DNS
127.0.0.1 grafana.localhost nocodb.localhost portainer.localhost sonarqube.localhost
```

## 📚 Integration Examples

### Grafana Dashboards
```bash
# Import pre-built dashboards for Docker monitoring
# Dashboard IDs: 193, 179, 1860 (from grafana.com)
```

### SonarQube Analysis
```bash
# Analyze project with Maven
mvn sonar:sonar -Dsonar.host.url=http://sonarqube.localhost

# Analyze project with npm
npm install -g sonarqube-scanner
sonar-scanner -Dsonar.host.url=http://sonarqube.localhost
```

### NocoDB API Usage
```bash
# Auto-generated REST API
curl -X GET "http://nocodb.localhost/api/v1/db/data/noco/your-table"

# GraphQL API
curl -X POST "http://nocodb.localhost/api/v1/db/data/noco/your-table/graphql"
```

## 🔄 Updates & Maintenance

### Update All Services
```bash
# Pull latest images
docker-compose pull

# Recreate containers with new images
docker-compose up -d

# Clean up old images
docker image prune -f
```

### Health Monitoring
```bash
# Check service health
docker-compose ps
docker-compose top

# Monitor resource usage
docker stats
```

## 🤝 Contributing

1. Fork the repository
2. Create feature branch: `git checkout -b feature/amazing-feature`
3. Test your changes with the full stack
4. Commit changes: `git commit -m 'Add amazing feature'`
5. Push branch: `git push origin feature/amazing-feature`
6. Create Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](../LICENSE) file for details.

---

**🎉 Happy coding with the Quizzby Docker Stack!**

*Last updated: October 30, 2025*