#!/bin/bash
# ==============================================
# Jenkins on Oracle Cloud Free Tier (1GB RAM)
# Ubuntu 24.04 - VM.Standard.E2.1.Micro
# ==============================================

echo "============================================"
echo "  Step 1: Adding 2GB Swap (needed for 1GB RAM)"
echo "============================================"
sudo fallocate -l 2G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
echo "Swap enabled!"
free -h

echo ""
echo "============================================"
echo "  Step 2: Installing Docker"
echo "============================================"
# Update packages
sudo apt-get update -y

# Install prerequisites
sudo apt-get install -y ca-certificates curl gnupg

# Add Docker's official GPG key
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Add Docker repository
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker
sudo apt-get update -y
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Add current user to docker group
sudo usermod -aG docker $USER

echo ""
echo "============================================"
echo "  Step 3: Creating Jenkins Docker Compose"
echo "============================================"
mkdir -p ~/jenkins
cat > ~/jenkins/docker-compose.yml << 'EOF'
version: '3.8'

services:
  jenkins:
    image: jenkins/jenkins:lts
    container_name: jenkins
    restart: unless-stopped
    user: root
    ports:
      - "8080:8080"
      - "50000:50000"
    volumes:
      - jenkins_data:/var/jenkins_home
    environment:
      # Optimized for 1GB RAM Oracle Free Tier
      - JAVA_OPTS=-Xmx384m -Xms256m -XX:+UseG1GC -XX:MaxMetaspaceSize=150m
    deploy:
      resources:
        limits:
          memory: 800m

volumes:
  jenkins_data:
EOF

echo ""
echo "============================================"
echo "  Step 4: Opening Firewall Port 8080"
echo "============================================"
sudo iptables -I INPUT 6 -m state --state NEW -p tcp --dport 8080 -j ACCEPT
sudo netfilter-persistent save

echo ""
echo "============================================"
echo "  Step 5: Starting Jenkins"
echo "============================================"
cd ~/jenkins
sudo docker compose up -d

echo ""
echo "Waiting for Jenkins to start (this takes 1-2 minutes on free tier)..."
sleep 60

# Check if Jenkins is running
until curl -s http://localhost:8080 > /dev/null 2>&1; do
  echo "Still waiting for Jenkins..."
  sleep 10
done

echo ""
echo "============================================"
echo "  ✅ JENKINS IS RUNNING!"
echo "============================================"
echo ""
echo "Your Jenkins Initial Admin Password is:"
echo "-------------------------------------------"
sudo docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
echo ""
echo "-------------------------------------------"
echo ""
echo "Open Jenkins in your browser at:"
echo "  http://<YOUR_SERVER_PUBLIC_IP>:8080"
echo ""
echo "Paste the password above to unlock Jenkins!"
echo "============================================"
