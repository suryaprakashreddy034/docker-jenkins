# Jenkins on Docker (GitHub Codespaces)

Run Jenkins in the cloud for **FREE** using GitHub Codespaces — no credit card, no local setup required!

## 🚀 Quick Start

### Step 1: Push this repo to GitHub
Open your terminal (PowerShell) and run:
```bash
cd C:\Users\surya\Documents\docker-jenkins
git init
git add .
git commit -m "Jenkins Docker setup for Codespaces"
```
Then go to [github.com/new](https://github.com/new), create a new repository called `docker-jenkins`, and push:
```bash
git remote add origin https://github.com/YOUR_USERNAME/docker-jenkins.git
git branch -M main
git push -u origin main
```

### Step 2: Launch Codespace
1. Go to your new GitHub repo in the browser.
2. Click the green **Code** button.
3. Click the **Codespaces** tab.
4. Click **Create codespace on main**.

### Step 3: Wait for Setup
The Codespace will automatically:
- ✅ Set up a cloud Linux environment
- ✅ Install Docker
- ✅ Pull the Jenkins Docker image
- ✅ Start the Jenkins container
- ✅ Print your **initial admin password** in the terminal

### Step 4: Access Jenkins
- A popup will appear saying "Port 8080 is available" — click **Open in Browser**.
- Or go to the **Ports** tab at the bottom and click the globe icon 🌐 next to port `8080`.
- Paste the **initial admin password** from the terminal to log in.

## 📁 Project Structure
```
docker-jenkins/
├── .devcontainer/
│   ├── devcontainer.json   # Codespaces configuration
│   └── setup.sh            # Auto-setup script
├── docker-compose.yml      # Jenkins container definition
└── README.md               # This file
```

## 🔑 Getting the Admin Password Again
If you need to see the password again, run this in the Codespace terminal:
```bash
docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
```

## ⚠️ Important Notes
- Codespaces gives you **60 free hours/month**.
- Your Jenkins data persists within the Codespace as long as you don't delete it.
- Stop your Codespace when not in use to save hours (it auto-stops after 30 minutes of inactivity).
