#!/bin/bash

# Portainer Setup Script
# This script initializes Portainer with a secure admin password

set -e

echo "🚀 Setting up Portainer..."

# Create data directory if it doesn't exist
mkdir -p ./data

# Generate secure admin password if not exists
if [ ! -f "./data/admin_password" ]; then
    echo "🔐 Generating secure admin password..."
    
    # Generate a random password
    ADMIN_PASSWORD=$(openssl rand -base64 32 | tr -d "=+/" | cut -c1-25)
    
    # Hash the password for Portainer
    echo -n "$ADMIN_PASSWORD" | docker run --rm -i portainer/helper-reset-password 2>/dev/null > ./data/admin_password
    
    echo "✅ Admin password generated and saved to ./data/admin_password"
    echo "📝 Your admin password is: $ADMIN_PASSWORD"
    echo "⚠️  Please save this password - it won't be shown again!"
    echo ""
    echo "💾 You can also find the hashed version in ./data/admin_password"
else
    echo "ℹ️  Admin password file already exists"
fi

echo "🔧 Starting Portainer..."
docker-compose up -d

echo "⏳ Waiting for Portainer to start..."
sleep 10

echo "✅ Portainer setup complete!"
echo "🌐 Access Portainer at:"
echo "   - HTTP:  http://localhost:9000"
echo "   - HTTPS: https://localhost:9443"
echo ""
echo "👤 Login with:"
echo "   - Username: admin"
echo "   - Password: [the password shown above]"