# GitOps

# GitOps Environment Variables
echo "USERNAME:"
read -s DOCKER_USERNAME
export DOCKER_USERNAME=$DOCKER_USERNAME
export VERSION="i"
export APP_NAME="app-gitops-$VERSION"
export FIREWALL_RULES_NAME="$APP_NAME-ports"


# Infrastructure
source env*
sh infra*

# kubectl and minikube
sh GitOps.sh

# Build the image and ush to the repository
cd app
docker build -t $DOCKER_USERNAME/app .
cd ..
# hub.docker.com/repositories
# Login Docker
docker login
# Docker Images
docker images
# Push to Docker Hub
docker push $DOCKER_USERNAME/app
# Docker logout
docker logout

# Deploy locally (kubectl)
# Create app.yaml manifest
cat > manifest/app.yaml << EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: app-deployment
  labels: 
    app: app
spec:
  replicas: 3
  selector: 
    matchLabels:
      app: app
  template:
    metadata: 
      labels:
        app: app
    spec:
      containers:
      - name: app
        image: $DOCKER_USERNAME/app:latest
        ports:
        - containerPort: 9000
EOF

# Create app namespace
kubectl create namespace app
# Apply deployment
kubectl apply -f manifest/app.yaml -n app
kubectl get all -n app
watch kubectl get all -n app
kubectl expose deployment.apps/app-deployment -n app
kubectl get all -n app
kubectl port-forward service/app-deployment 9000:9000 --address 0.0.0.0 -n app
kubectl get pods -n app

# Create a firewall
gcloud compute --project=$(gcloud config get project) firewall-rules create $FIREWALL_RULES_NAME-local \
    --direction=INGRESS --priority=1000 --network=default --action=ALLOW --rules=tcp:9000 --source-ranges=0.0.0.0/0

########## Cleanup GitOps
rm -rf manifest/app.yaml
gcloud compute firewall-rules delete $FIREWALL_RULES_NAME-local --quiet 