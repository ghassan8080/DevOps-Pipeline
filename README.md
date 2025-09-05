# DevOps Pipeline Project

This project demonstrates a complete DevOps pipeline for a microservice application using PHP, Apache, MySQL, and monitoring with Prometheus & Grafana. It includes automation with Docker, Ansible, Kubernetes, Terraform, and Jenkins.

## Project Structure

```
├── docker/                # Dockerfile & docker-compose.yml
├── ansible/               # Ansible playbook
├── kubernetes/            # Kubernetes manifests
├── terraform/             # Terraform scripts for Jenkins EC2
├── jenkins/               # Jenkinsfiles for automation
├── install.sh             # EC2 install script
└── README.md              # Project documentation
```

## Step-by-Step Guide

### 1. Provision Jenkins EC2 Instance
- Configure `terraform.tfvars` with your AWS region, AMI, and keypair.
- Run:
  ```
  cd terraform
  terraform init
  terraform apply -auto-approve
  ```

### 2. Connect to EC2
- Use SSH with your keypair:
  ```
  ssh -i file.pem ubuntu@<public-ip>
  ```

### 3. Install Dependencies
- Copy and run `install.sh` on the EC2 instance:
  ```
  chmod +x install.sh
  ./install.sh
  ```

### 4. Verify Installations
- Check versions:
  ```
  java -version
  jenkins --version
  docker --version
  ansible --version
  docker-compose --version
  eksctl version
  minikube version
  k9s version
  aws --version
  ```

### 5. Access Jenkins
- Open `<EC2-public-ip>:8080` in your browser.

### 6. Add Credentials in Jenkins
- **Install CloudBees AWS Credentials plugin**:
  1. Go to `Manage Jenkins` > `Manage Plugins`
  2. Click on the `Available` tab
  3. Search for "CloudBees AWS Credentials"
  4. Select the plugin and click "Install without restart"

- **Add DockerHub Credentials**:
  1. Go to `Manage Jenkins` > `Manage Credentials`
  2. Under "Stores scoped to Jenkins", click on `(global)`
  3. Click "Add Credentials"
  4. Select kind: "Username with password"
  5. Scope: "Global"
  6. Username: Your DockerHub username
  7. Password: Your DockerHub password or personal access token
  8. ID: "dockerhub-credentials" (this will be referenced in Jenkinsfile)
  9. Description: "DockerHub credentials"
  10. Click "OK"

- **Add GitHub Credentials**:
  1. Go to `Manage Jenkins` > `Manage Credentials`
  2. Under "Stores scoped to Jenkins", click on `(global)`
  3. Click "Add Credentials"
  4. Select kind: "Username with password"
  5. Scope: "Global"
  6. Username: Your GitHub username
  7. Password: Your GitHub personal access token (with repo permissions)
  8. ID: "github-credentials" (this will be referenced in Jenkinsfile)
  9. Description: "GitHub credentials"
  10. Click "OK"

- **Add AWS Credentials**:
  1. Go to `Manage Jenkins` > `Manage Credentials`
  2. Under "Stores scoped to Jenkins", click on `(global)`
  3. Click "Add Credentials"
  4. Select kind: "AWS Credentials" (this option appears after installing CloudBees AWS Credentials plugin)
  5. Scope: "Global"
  6. Access Key: Your AWS access key ID
  7. Secret Key: Your AWS secret access key
  8. ID: "aws-credentials" (this will be referenced in Jenkinsfile)
  9. Description: "AWS credentials"
  10. Click "OK"

### 7. Jenkins Jobs
- **Jenkins-EKS**: Creates EKS cluster and namespace.
- **Jenkins-Deploy**: Deploys microservices and monitoring.
- **Jenkins-RM-EKS**: Deletes the EKS cluster.

## Notes
- Kubernetes manifests and Terraform files may need resource limits and further production hardening.
- Update all credentials and secrets before deploying.

---
For any issues, review each step and check the respective configuration files.
