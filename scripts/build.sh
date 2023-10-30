#!/bin/bash

VERSION=$(cat version)
if [[ -z "$VERSION" ]]; then
  echo "Version is empty!"
  exit 1
fi

DOCKERFILE="Dockerfile"
DOCKERHUB_USERNAME="boriskaro"
REPO_NAME="postwp-wp-base"

echo "Building image with tag $VERSION..."

docker buildx build --push --platform linux/amd64,linux/arm64 --build-arg VERSION=$VERSION \
  -t $DOCKERHUB_USERNAME/$REPO_NAME:$VERSION \
  -t $DOCKERHUB_USERNAME/$REPO_NAME:latest \
  -f $DOCKERFILE .

if [ $? -eq 0 ]; then
  echo "Build was successful."
else
  echo "Build failed."
  exit 1
fi