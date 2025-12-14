#!/usr/bin/env bash
set -e

APP_DIR="/opt/node-app"
IMAGE="$IMAGE_NAME:latest"
CONTAINER_NAME="node-app"

echo "Creating app directory..."
mkdir -p "$APP_DIR"

echo "Writing environment variables..."
cat > "$APP_DIR/.env" << ENVEOF
MONGO_USERNAME=${MONGO_USERNAME}
MONGO_PASSWORD=${MONGO_PASSWORD}
ENVEOF

chmod 600 "$APP_DIR/.env"

echo "Pulling latest Docker image..."
docker pull "$IMAGE"

echo "Stopping existing container (if any)..."
docker stop "$CONTAINER_NAME" || true
docker rm "$CONTAINER_NAME" || true

echo "Starting new container..."
docker run -d \
  --name "$CONTAINER_NAME" \
  --env-file "$APP_DIR/.env" \
  -p 3000:3000 \
  --restart unless-stopped \
  "$IMAGE"

echo "Deployment complete."
