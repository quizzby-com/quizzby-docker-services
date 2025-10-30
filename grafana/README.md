# Grafana Service

This directory contains the Docker configuration for Grafana monitoring and observability platform.

## Quick Start

```bash
# Copy environment file and configure
cp .env.example .env
# Edit .env with your settings

# Start Grafana
docker-compose up -d

# View logs
docker-compose logs -f grafana
```

## Access

- **URL**: http://localhost:3000
- **Default Login**: admin / admin123 (change in .env file)

## Features

- ✅ Persistent data storage
- ✅ Custom configuration
- ✅ Plugin support (clock panel, simple JSON datasource)
- ✅ Security hardened (no signup, no gravatar)
- ✅ Production ready

## Configuration

- **Config**: `config/grafana.ini`
- **Environment**: `.env` file
- **Data**: Stored in Docker volume `grafana-data`
- **Provisioning**: `provisioning/` directory for automated setup

## Common Commands

```bash
# Start service
docker-compose up -d

# Stop service
docker-compose down

# View logs
docker-compose logs -f

# Update to latest
docker-compose pull && docker-compose up -d

# Backup data
docker run --rm -v grafana-data:/data -v $(pwd):/backup alpine tar czf /backup/grafana-backup.tar.gz -C /data .
```

## Integration

This service is part of the Quizzby monitoring stack and connects to the shared `quizzby-network`.