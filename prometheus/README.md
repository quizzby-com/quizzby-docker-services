# Quizzby Monitoring Stack - README

This directory contains the complete Prometheus monitoring stack for the Quizzby infrastructure.

## Services Added

### Prometheus (metrics collector)
- **URL**: https://prometheus.quizzby.com
- **Port**: 9090
- **Purpose**: Collects and stores metrics from all services
- **Configuration**: `prometheus/prometheus.yml`
- **Alert Rules**: `prometheus/alert_rules.yml`

### Node Exporter (system metrics)
- **Port**: 9100 (internal)
- **Purpose**: Exports system-level metrics (CPU, memory, disk, network)
- **Metrics Path**: `/metrics`

### cAdvisor (container metrics)
- **Port**: 8080 (internal)
- **Purpose**: Exports Docker container metrics
- **Metrics Path**: `/metrics`

## Grafana Integration

### Data Sources
- Prometheus data source automatically configured in `grafana/provisioning/datasources/prometheus.yml`
- No manual configuration needed - Grafana will automatically discover Prometheus

### Dashboards
Two pre-built dashboards are automatically provisioned:

1. **Infrastructure Monitoring** (`infrastructure.json`)
   - System CPU, Memory, Disk usage
   - Network traffic
   - Real-time system health metrics

2. **Container Monitoring** (`containers.json`)
   - Container CPU and memory usage
   - Container network traffic
   - Service status overview

## Alert Rules

Prometheus is configured with the following alert rules:

- **HighCpuUsage**: Triggered when CPU usage > 80% for 5+ minutes
- **HighMemoryUsage**: Triggered when memory usage > 85% for 5+ minutes
- **LowDiskSpace**: Triggered when disk usage > 90% for 5+ minutes
- **ServiceDown**: Triggered when any service is down for 1+ minute
- **ContainerHighCpuUsage**: Triggered when container CPU > 80% for 5+ minutes
- **ContainerHighMemoryUsage**: Triggered when container memory > 85% for 5+ minutes

## Getting Started

1. **Deploy the monitoring stack**:
   ```bash
   cd /path/to/quizzby-docker-services
   docker compose -f docker-compose.production.yml up -d prometheus node-exporter cadvisor
   ```

2. **Restart Grafana** to load new configurations:
   ```bash
   docker compose -f docker-compose.production.yml restart grafana
   ```

3. **Access the services**:
   - Grafana: https://grafana.quizzby.com
   - Prometheus: https://prometheus.quizzby.com

4. **View dashboards**:
   - Login to Grafana with your admin credentials
   - Navigate to Dashboards
   - Select "Quizzby Infrastructure Monitoring" or "Quizzby Container Monitoring"

## Metrics Collection

### System Metrics (Node Exporter)
- CPU usage per core and total
- Memory usage and availability
- Disk space and I/O statistics
- Network interface statistics
- System load averages
- Process and file descriptor counts

### Container Metrics (cAdvisor)
- Container CPU usage and throttling
- Container memory usage and limits
- Container network traffic
- Container filesystem usage
- Container restart counts
- Container health status

### Service Metrics (Prometheus)
- Service uptime and availability
- Query performance and response times
- Storage usage and retention
- Alert rule evaluations

## Customization

### Adding New Metrics Sources
Edit `prometheus/prometheus.yml` and add new scrape configs:

```yaml
scrape_configs:
  - job_name: 'my-service'
    static_configs:
      - targets: ['my-service:8080']
```

### Creating Custom Dashboards
1. Create dashboard in Grafana UI
2. Export dashboard JSON
3. Save to `grafana/provisioning/dashboards/`
4. Restart Grafana to load automatically

### Custom Alert Rules
Edit `prometheus/alert_rules.yml` to add new alerts:

```yaml
- alert: MyCustomAlert
  expr: my_metric > 100
  for: 5m
  labels:
    severity: warning
  annotations:
    summary: "Custom alert triggered"
```

## Troubleshooting

### Prometheus Not Collecting Metrics
1. Check Prometheus targets: https://prometheus.quizzby.com/targets
2. Verify service connectivity
3. Check Docker network configuration

### Grafana Not Showing Data
1. Verify Prometheus data source configuration
2. Check data source connectivity in Grafana settings
3. Ensure dashboards are using correct data source UID

### High Resource Usage
1. Adjust Prometheus retention period in `prometheus.yml`
2. Reduce scrape intervals for less critical metrics
3. Use recording rules for expensive queries

## Security

- All services are behind Traefik reverse proxy with SSL
- Prometheus and metrics endpoints are internal to Docker network
- Only Grafana dashboard is exposed externally
- Authentication required for Grafana access

## Maintenance

### Data Retention
- Prometheus retains metrics for 15 days by default
- Adjust `--storage.tsdb.retention.time` in docker-compose.yml if needed

### Backup
- Prometheus data: `/var/lib/prometheus` volume
- Grafana data: `/var/lib/grafana` volume
- Configuration files: This repository

### Updates
- Monitor for new versions of Prometheus, Grafana, Node Exporter, cAdvisor
- Test updates in development environment first
- Backup data before major version upgrades