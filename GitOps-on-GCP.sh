# GitOps

# GitOps Environment Variables
echo "USERNAME:"
read -s DOCKER_USERNAME


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
