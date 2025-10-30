# NocoDB Service

This directory contains the Docker configuration for NocoDB - an open-source Airtable alternative.

## Features

- ✅ No-code database platform
- ✅ REST & GraphQL APIs
- ✅ PostgreSQL backend
- ✅ Persistent data storage
- ✅ Multi-user support
- ✅ Role-based permissions

## Quick Start

```bash
# Copy environment file and configure
cp .env.example .env
# Edit .env with your secure passwords

# Start NocoDB with database
docker-compose up -d

# View logs
docker-compose logs -f nocodb
```

## Access

- **URL**: http://localhost:8080
- **Admin Email**: Set in .env file (default: admin@quizzby.com)
- **Admin Password**: Set in .env file

## Database

- **Type**: PostgreSQL 15
- **Container**: quizzby-nocodb-db
- **Data**: Persistent in Docker volume
- **Port**: Internal only (not exposed)

## Common Commands

```bash
# Start services
docker-compose up -d

# Stop services
docker-compose down

# View logs
docker-compose logs -f

# Update to latest
docker-compose pull && docker-compose up -d

# Database backup
docker-compose exec postgres pg_dump -U nocodb nocodb > backup.sql

# Database restore
docker-compose exec -T postgres psql -U nocodb -d nocodb < backup.sql
```

## Integration

This service connects to the shared `quizzby-network` and can be accessed by other services in the stack.