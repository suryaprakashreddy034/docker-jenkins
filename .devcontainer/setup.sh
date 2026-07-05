#!/bin/bash
echo "============================================"
echo "  Setting up Jenkins with Docker..."
echo "============================================"

# Start Jenkins using Docker Compose
docker compose up -d

# Wait for Jenkins to fully start
echo ""
echo "Waiting for Jenkins to start (this takes about 30-60 seconds)..."
sleep 30

# Check if Jenkins is running
until curl -s http://localhost:8080 > /dev/null 2>&1; do
  echo "Still waiting for Jenkins..."
  sleep 5
done

echo ""
echo "============================================"
echo "  Jenkins is RUNNING!"
echo "============================================"

# Get the initial admin password
echo ""
echo "Your Jenkins Initial Admin Password is:"
echo "-------------------------------------------"
docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
echo ""
echo "-------------------------------------------"
echo ""
echo "COPY the password above, then open the"
echo "forwarded port 8080 URL to access Jenkins!"
echo "============================================"
