#!/bin/bash

IMAGE_NAME="a516/devops-build-dev"
TAG="latest"
CONTAINER_NAME="react_container"
HOST_PORT=80
CONTAINER_PORT=80

echo "Checking existing container..."

docker stop react_container 2>/dev/null || true
docker rm react_container 2>/dev/null || true

echo "Pulling latest image..."
docker pull a516/devops-build-dev:latest || exit 1

echo "Deploying new container..."

docker run -d \
  --name react_container \
  -p 80:80 \
  --restart always \
  a516/devops-build-dev:latest || exit 1

echo "Deployment successful"
echo "Application running on port 80"
exit 0
