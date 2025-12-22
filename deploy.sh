#!/bin/bash

# Configuration
IMAGE_NAME="devops-build"
TAG="latest"
CONTAINER_NAME="react_container"
HOST_PORT=80
CONTAINER_PORT=80

echo " Checking existing container..."

# Stop and remove existing container if it exists
if [ "$(docker ps -aq -f name=react_container)" ]; then
  echo " Stopping existing container..."
  docker stop react_container

  echo " Removing existing container..."
  docker rm react_container
fi

echo " Deploying new container..."

docker run -d \
  --name react_container \
  -p 80:80 \
  --restart always \
  devops-build:latest

# Check deployment status
if [ $? -eq 0 ]; then
  echo "Deployment successful"
  echo "Application is running on http://localhost:80"
else
  echo "Deployment failed"
  exit 1
fi
