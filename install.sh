#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

# --- Script Start ---
echo "Starting comprehensive server setup script..."

# --- 1. Update System Packages ---
echo "Updating package lists..."
sudo apt update

# --- 2. Install Core APT Packages ---
# Install Java, Docker, Docker Compose, Ansible, and GnuPG in one command for efficiency.
# -y flag automatically confirms the installation.
echo "Installing core packages (OpenJDK 11, Docker, Docker Compose, Ansible, GnuPG)..."
sudo apt install -y openjdk-11-jdk docker.io docker-compose ansible gnupg2

# --- 3. Install Docker ---
# The official Docker script is the recommended way to install the latest version.
echo "Installing the latest version of Docker..."
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Add the current user to the docker group to run docker commands without sudo.
# Note: You will need to log out and log back in for this to take full effect.
echo "Adding user '$USER' to the docker group..."
sudo usermod -aG docker $USER

# Ensure Docker is started and enabled to run on boot
echo "Starting and enabling Docker service..."
sudo systemctl start docker
sudo systemctl enable docker

# --- 4. Install AWS CLI ---
# Using snap for a reliable and self-contained installation.
echo "Installing AWS CLI via snap..."
sudo snap install aws-cli --classic

# --- 5. Install Jenkins ---
# Using snap for a reliable and self-contained installation.
echo "Installing Jenkins via snap..."
sudo snap install jenkins --classic

# --- 6. Install Kubernetes Tools (eksctl, minikube, k9s) ---
# These tools are installed by downloading the latest binaries and moving them to /usr/local/bin.

# Install eksctl for EKS cluster management
echo "Installing eksctl..."
curl -LO "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz"
tar -xzf eksctl_$(uname -s)_amd64.tar.gz
sudo mv eksctl /usr/local/bin
rm eksctl_$(uname -s)_amd64.tar.gz # Clean up

# Install minikube for local Kubernetes clusters
echo "Installing minikube..."
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
rm minikube-linux-amd64 # Clean up

# Install k9s for a Kubernetes CLI dashboard
echo "Installing k9s..."
curl -sS https://webinstall.dev/k9s | bash

# --- 7. Final Verification and Information ---
echo "-----------------------------------------------------"
echo "Setup script finished successfully!"
echo "-----------------------------------------------------"
echo ""
echo "Verifying installations:"
echo "-------------------------"
echo "Java Version:"
java -version
echo ""
echo "Docker Version:"
docker --version
echo ""
echo "AWS CLI Version:"
aws --version
echo ""
echo "Jenkins Service Status:"
sudo snap services jenkins
echo ""
echo "eksctl Version:"
eksctl version
echo ""
echo "minikube Version:"
minikube version
echo ""
echo "-----------------------------------------------------"
echo "IMPORTANT NEXT STEPS:"
echo "1. Log out and SSH back into the server for the 'docker' group changes to take effect."
echo "2. To access the Jenkins web interface, you MUST open port 8080 in your AWS EC2 Security Group."
echo "   - Go to AWS EC2 Console -> Security Groups -> Edit Inbound Rules."
echo "   - Add a 'Custom TCP' rule for port 8080 with source 'My IP'."
echo "3. After opening the port, get the initial Jenkins admin password with this command:"
echo "   sudo cat /var/snap/jenkins/current/initialAdminPassword"
echo "4. You can then access Jenkins at: http://<YOUR_EC2_PUBLIC_IP>:8080"
echo "-----------------------------------------------------"

# --- Script End ---
