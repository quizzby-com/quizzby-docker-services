#!/bin/bash
# Portainer Password Setup Script
# This script generates a random password and sets up Portainer admin user

set -e

echo "🔑 Portainer Password Setup"

# Generate a random password
PORTAINER_PASSWORD=$(openssl rand -base64 32 | tr -d "=+/" | cut -c1-20)

echo "Generated password: $PORTAINER_PASSWORD"

# Update .env file with the password
if [ -f ".env" ]; then
    # Add or update PORTAINER_ADMIN_PASSWORD in .env
    if grep -q "PORTAINER_ADMIN_PASSWORD" .env; then
        sed -i "s/PORTAINER_ADMIN_PASSWORD=.*/PORTAINER_ADMIN_PASSWORD=$PORTAINER_PASSWORD/" .env
    else
        echo "PORTAINER_ADMIN_PASSWORD=$PORTAINER_PASSWORD" >> .env
    fi
    echo "✅ Password added to .env file"
else
    echo "❌ .env file not found. Please create it first."
    exit 1
fi

# Save credentials to file
cat >> /home/ubuntu/service-credentials.txt << EOF

Portainer:
- URL: https://portainer.quizzby.com
- Direct URL: http://$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4):9000
- Username: admin
- Password: $PORTAINER_PASSWORD
- Note: Use this password during first-time setup

EOF

echo "🎯 Portainer Setup Instructions:"
echo "1. Stop current Portainer: docker stop quizzby-portainer"
echo "2. Remove Portainer data: docker volume rm portainer-data"
echo "3. Restart Portainer: docker compose -f docker-compose.production.yml up -d portainer"
echo "4. Access: https://portainer.quizzby.com or http://YOUR_SERVER_IP:9000"
echo "5. Create admin user with username 'admin' and the generated password"
echo ""
echo "💾 Your Portainer password: $PORTAINER_PASSWORD"
echo "📝 Credentials saved to: /home/ubuntu/service-credentials.txt"