# SonarQube Service

This directory contains the Docker configuration for SonarQube - continuous code quality and security analysis.

## Features

- ✅ Code quality analysis
- ✅ Security vulnerability detection
- ✅ Technical debt tracking
- ✅ Multiple language support
- ✅ PostgreSQL backend
- ✅ Persistent data storage

## Quick Start

```bash
# Copy environment file and configure
cp .env.example .env
# Edit .env with your secure passwords

# Start SonarQube with database
docker-compose up -d

# View logs
docker-compose logs -f sonarqube
```

## Access

- **URL**: http://localhost:9001
- **Default Login**: admin / admin
- **⚠️ Change password** after first login!

## System Requirements

SonarQube requires specific system settings:

```bash
# Increase virtual memory (on Docker host)
sudo sysctl -w vm.max_map_count=524288
sudo sysctl -w fs.file-max=131072

# Make permanent
echo 'vm.max_map_count=524288' | sudo tee -a /etc/sysctl.conf
echo 'fs.file-max=131072' | sudo tee -a /etc/sysctl.conf
```

## Database

- **Type**: PostgreSQL 15
- **Container**: quizzby-sonarqube-db
- **Optimized**: Custom settings for SonarQube performance
- **Health Checks**: Automatic monitoring

## Analysis Setup

### 1. Generate Token
1. Login to SonarQube
2. Go to User → My Account → Security
3. Generate token for project analysis

### 2. Analyze Project
```bash
# Using SonarScanner CLI
sonar-scanner \
  -Dsonar.projectKey=my-project \
  -Dsonar.sources=. \
  -Dsonar.host.url=http://localhost:9001 \
  -Dsonar.login=your-token-here

# Using Maven
mvn sonar:sonar \
  -Dsonar.host.url=http://localhost:9001 \
  -Dsonar.login=your-token-here

# Using Gradle
./gradlew sonarqube \
  -Dsonar.host.url=http://localhost:9001 \
  -Dsonar.login=your-token-here
```

## Common Commands

```bash
# Start services
docker-compose up -d

# Stop services
docker-compose down

# View logs
docker-compose logs -f sonarqube

# Update to latest
docker-compose pull && docker-compose up -d

# Database backup
docker-compose exec postgres pg_dump -U sonarqube sonarqube > sonarqube-backup.sql

# Restart SonarQube only
docker-compose restart sonarqube
```

## Plugin Management

Access plugins via:
1. Administration → Marketplace
2. Install plugins (JavaScript, Python, C#, etc.)
3. Restart SonarQube

## Integration

This service connects to the shared `quizzby-network` and can analyze code from other services in the stack.