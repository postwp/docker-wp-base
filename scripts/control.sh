#!/bin/bash

source version
echo "Current version: $VERSION"
IFS='.' read -ra VERSION_PARTS <<< "$VERSION"

MAJOR=${VERSION_PARTS[0]}
MINOR=${VERSION_PARTS[1]}
PATCH=${VERSION_PARTS[2]}

PS3='Enter which part to increment: '
options=("major" "minor" "patch")
select opt in "${options[@]}"
do
    echo "Incrementing $opt version from $VERSION"
    case $opt in
        "major")
        MAJOR=$((MAJOR + 1))
        MINOR=0
        PATCH=0
        break
        ;;
        "minor")
        MINOR=$((MINOR + 1))
        PATCH=0
        break
        ;;
        "patch")
        PATCH=$((PATCH + 1))
        break
        ;;
        *)
        echo "Invalid option $REPLY"
        ;;
    esac
done

NEW_VERSION="$MAJOR.$MINOR.$PATCH"
echo "New version: $NEW_VERSION"
echo "VERSION=$NEW_VERSION" > version
echo "Version updated to $NEW_VERSION"