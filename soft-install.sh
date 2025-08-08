sudo apt update
sudo apt upgrade -y
#Docker
curl https://get.docker.com | bash
sudo usermod -aG docker $USER
newgrp docker
sudo systemctl stop docker 
sudo systemctl enable --now docker 
sudo systemctl start docker

#Jenkins Install
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]" \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update
sudo apt install openjdk-17-jdk -y
sudo apt-get install jenkins -y

sudo systemctl enable jenkins
sudo systemctl start jenkins
sudo systemctl status jenkins

sudo usermod -aG docker jenkins
newgrp docker

#Run Nexus as container

docker run -d \
  --name nexus \
  -p 8081:8081 \
  -v /home/ubuntu/nexus:/nexus-data \
  sonatype/nexus3:latest
  #Give 777 for /home/ubuntu/nexus
sudo chown -R 200:200 /home/ubuntu/nexus
sudo chmod -R 755 /home/ubuntu/nexus


  docker run -d \
  --name sonar \
  -p 9000:9000 \
  -v /home/ubuntu/sonar:/opt/sonarqube/data \
  -v /home/ubuntu/sonar/extensions:/opt/sonarqube/extensions \
  -v /home/ubuntu/sonar/logs:/opt/sonarqube/logs \
  sonarqube:lts-community

sudo chown -R 1000:1000 /home/ubuntu/sonar
sudo chmod -R 755 /home/ubuntu/sonar

sudo apt update
sudo apt install unzip -y
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

jenkins ALL=(ALL) NOPASSWD: ALL

Plugins
Eclipse Temurin installer
Pipeline Maven
Config File Provider:
SonarQube Scanner:
Docker
Docker Pipeline
Kubernetes

#Trivy Install
sudo apt-get install wget apt-transport-https gnupg lsb-release -y
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | sudo apt-key add -
echo deb https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main | sudo tee -a /etc/apt/sources.list.d/trivy.list
sudo apt-get update
sudo apt-get install trivy -y
jenkins ALL=(ALL) NOPASSWD: ALL

http://34.230.23.115:8080/sonarqube-webhook/

eksctl create cluster \
  --name my-cluster \
  --region us-east-1 \
  --version 1.28 \
  --nodegroup-name ng-high-ip \
  --node-type t3.medium \
  --nodes 2 \
  --nodes-min 2 \
  --nodes-max 5 \
  --max-pods-per-node 110 \
  --ssh-access \
  --ssh-public-key AWSHYD  # Replace with your SSH key name

  aws eks update-kubeconfig --region us-east-1 --name my-cluster


  apiVersion: v1
kind: ServiceAccount
metadata:
  name: jenkins-sa
  namespace: webapps


apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  namespace: webapps
  name: jenkins-role
rules:
- apiGroups: [""]
  resources: ["pods", "services", "deployments"]
  verbs: ["get", "list", "create", "update", "delete"]



apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: jenkins-rolebinding
  namespace: webapps
subjects:
- kind: ServiceAccount
  name: jenkins-sa
  namespace: webapps
roleRef:
  kind: Role
  name: jenkins-role
  apiGroup: rbac.authorization.k8s.io


SECRET_NAME=$(kubectl get serviceaccount jenkins-sa -n webapps -o jsonpath='{.secrets[0].name}')
kubectl get secret $SECRET_NAME -o jsonpath='{.data.token}' | base64 --decode


kubectl create secret generic jenkins-sa-token --from-literal=token=DSHADAHDAHDAHDKAHDAHDKADHAJHDAHD2424242 -n webapps

stage('Deploy To Kubernetes') {
    steps {
        withKubeConfig(caCertificate: '', clusterName: 'my-cluster', contextName: 'jenkins-context', credentialsId: 'k8-cred', namespace: 'webapps', restrictKubeConfigAccess: false, serverUrl: 'https://5A01BC8FADC3B1F2978C9BD0D1768FBF.gr7.us-east-1.eks.amazonaws.com') {
            sh "kubectl apply -f deployment-service.yaml"
        }
    }
}

apiVersion: v1
clusters:
- cluster:
    server: https://5A01BC8FADC3B1F2978C9BD0D1768FBF.gr7.us-east-1.eks.amazonaws.com
    certificate-authority-data: certificate-authority-data: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSURCVENDQWUyZ0F3SUJBZ0lJRDZ5bTQ4S0MwL1V3RFFZSktvWklodmNOQVFFTEJRQXdGVEVUTUJFR0ExVUUKQXhNS2EzVmlaWEp1WlhSbGN6QWVGdzB5TkRFd01UVXdOakU0TlRaYUZ3MHpOREV3TVRNd05qSXpOVFphTUJVeApFekFSQmdOVkJBTVRDbXQxWW1WeWJtVjBaWE13Z2dFaU1BMEdDU3FHU0liM0RRRUJBUVVBQTRJQkR3QXdnZ0VLCkFvSUJBUURkbmN1eUZjZGRDSk1Qbi9wU00zRmxSTmczSG0yRVVuR2JoNGZDbFVpVDFHbnBkc2o0Q0hwYXYvK1MKU0k2c3RyR0p5eWxHV1pFQnhPa1FMcXNGUXZVWWorVjNCckFTV1JRU0pJMTZBOTVUQ0dsMytHS0U1SzNOWmVNNApvY1c5dXVackYwbExZb1U1ak5qb2U1d2JaNnlWUGgwMC9qUUovdWd0NUQ5Uzg3RXZLeVVFUFZsc3BGY2pjL3kzCnRHK3diTnVQTUFUTDZPN1lOL241eStrVkovUnMyOHZrNUpHcmlNQk52WVlmYWliZWI4N280azg4YXFNOEV4R0wKSmVSSVFrVmpYa2J5cm9BY2YwbHA1Q0VzUUpCbVV2Z1NMcW5sWWVyOGVUVGwyanBSUUNKNGQwTzNmSWMzeERxMQpFajdVK0xGeWJGS3lsVnFEUTQwZkhTc09DZUZWQWdNQkFBR2pXVEJYTUE0R0ExVWREd0VCL3dRRUF3SUNwREFQCkJnTlZIUk1CQWY4RUJUQURBUUgvTUIwR0ExVWREZ1FXQkJUbC9PeFBpLzBwZFl3ZEhpd0N0aVgySm8rc0lUQVYKQmdOVkhSRUVEakFNZ2dwcmRXSmxjbTVsZEdWek1BMEdDU3FHU0liM0RRRUJDd1VBQTRJQkFRRE1uVHhLT2g0WQpicmxHclhJbzdOcmh5eVBqanF0dzA2U3A3bmREekxBT0lCTXZrU1ZtWTJwU0Z4U1MyMGJyMWFsdWNwME1pd2RRCnNYRWtYQkpOQ0VPanA0UXpZVlBLeDFCOWhRN1dPY0ZjL2N5cWo1Zm9zK2VzaWpiampnRmZONUJPREJkTGlHZ0MKNU9qY3hrdHN3NGZkNS9ZQlFscHNybTZ5T24yZnlOZWUwYlZPVVBlZFZDOFU5VUFtRlV6S1VwZHBMWmxCcnBxRApaOWQ2Vmh3c0dNdHVqSEpRSjBWTU5RMmVwTFBhLzNWY0pJdVBnZ091cmwxWml5aUM5bmd6NHVtdjBuSldZVUtoCkc2R1hwc2Z1TWxDUDBZalNBZEg5VXQyU09BV3RjWGlHR2lrMy8wZ081c2VaUHFOSHMvN3lBd3NBYTlIT3lEOHMKdHM0bWpGamNBMDRUCi0tLS0tRU5EIENFUlRJRklDQVRFLS0tLS0K
  name: my-cluster
contexts:
- context:
    cluster: my-cluster
    user: jenkins-sa
  name: jenkins-context
current-context: jenkins-context
users:
- name: jenkins-sa
  user:
    token: DSHADAHDAHDAHDKAHDAHDKADHAJHDAHD2424242
