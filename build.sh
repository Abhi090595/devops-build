#!/bin/bash

echo " Building Docker image..."

set -e

docker-compose down

docker-compose build --no-cache

echo "Docker image build completed successfully!"
