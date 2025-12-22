#!/bin/bash 

IMAGE_NAME="devops-build" 
TAG="latest" 

echo " Docker image build..." 

docker build -t devops-build:latest . 

if [ $? -eq 0 ]; then 
  echo "Docker image successfully build : devops-build:latest" 
else 
  echo "Docker image build failed" 
  exit 1 
fi