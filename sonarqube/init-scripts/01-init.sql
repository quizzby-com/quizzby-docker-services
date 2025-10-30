-- SonarQube Database Initialization Script
-- This script sets up additional database configurations if needed

-- Enable required extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Set optimal PostgreSQL settings for SonarQube
ALTER SYSTEM SET max_connections = 200;
ALTER SYSTEM SET shared_buffers = '256MB';
ALTER SYSTEM SET effective_cache_size = '1GB';
ALTER SYSTEM SET maintenance_work_mem = '64MB';
ALTER SYSTEM SET checkpoint_completion_target = 0.9;
ALTER SYSTEM SET wal_buffers = '16MB';
ALTER SYSTEM SET default_statistics_target = 100;

-- Reload configuration
SELECT pg_reload_conf();