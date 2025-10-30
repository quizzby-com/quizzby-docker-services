#!/bin/bash
# Traefik Password Setup Script
# This script generates a random password and updates Traefik basic auth configuration

set -e

echo "🔑 Traefik Password Setup"

# Generate a random password
TRAEFIK_PASSWORD=$(openssl rand -base64 32 | tr -d "=+/" | cut -c1-20)
echo "Generated password: $TRAEFIK_PASSWORD"

# Generate htpasswd hash for the password
TRAEFIK_HASH=$(docker run --rm httpd:2.4-alpine htpasswd -nbB admin "$TRAEFIK_PASSWORD" | sed 's/\$/\$\$/g')
echo "Generated hash: $TRAEFIK_HASH"

# Update .env file with the password
if [ -f ".env" ]; then
    # Add or update TRAEFIK_ADMIN_PASSWORD in .env
    if grep -q "TRAEFIK_ADMIN_PASSWORD" .env; then
        sed -i "s/TRAEFIK_ADMIN_PASSWORD=.*/TRAEFIK_ADMIN_PASSWORD=$TRAEFIK_PASSWORD/" .env
    else
        echo "TRAEFIK_ADMIN_PASSWORD=$TRAEFIK_PASSWORD" >> .env
    fi
    
    # Add or update TRAEFIK_AUTH_HASH in .env
    if grep -q "TRAEFIK_AUTH_HASH" .env; then
        sed -i "s|TRAEFIK_AUTH_HASH=.*|TRAEFIK_AUTH_HASH=$TRAEFIK_HASH|" .env
    else
        echo "TRAEFIK_AUTH_HASH=$TRAEFIK_HASH" >> .env
    fi
    
    echo "✅ Password and hash added to .env file"
else
    echo "❌ .env file not found. Please create it first."
    exit 1
fi

# Update credentials file
if [ -f "/home/ubuntu/service-credentials.txt" ]; then
    # Remove old Traefik entry if exists
    sed -i '/^Traefik Dashboard:/,/^$/d' /home/ubuntu/service-credentials.txt
fi

# Add new Traefik credentials
cat >> /home/ubuntu/service-credentials.txt << EOF

Traefik Dashboard:
- URL: https://traefik.quizzby.com
- Direct URL: http://$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4):8080
- Username: admin
- Password: $TRAEFIK_PASSWORD
- Note: Access the reverse proxy dashboard and certificate management

EOF

echo "🎯 Traefik Setup Instructions:"
echo "1. Update docker-compose files to use the generated hash"
echo "2. Restart Traefik: docker compose -f docker-compose.production.yml up -d traefik"
echo "3. Access: https://traefik.quizzby.com or http://YOUR_SERVER_IP:8080"
echo "4. Login with username 'admin' and the generated password"
echo ""
echo "💾 Your Traefik password: $TRAEFIK_PASSWORD"
echo "📝 Credentials saved to: /home/ubuntu/service-credentials.txt"
echo ""
echo "🔧 To apply the new password, run:"
echo "   docker compose -f docker-compose.production.yml up -d traefik"