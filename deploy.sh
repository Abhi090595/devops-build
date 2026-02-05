#!/bin/bash

echo "Deploying Docker-Build App..."

set -e

docker-compose down


docker-compose up -d

docker ps

echo "Deployment completed successfully!"
echo "App should be live on port 80"
