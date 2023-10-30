#!/bin/bash

increment_version() {
    VERSION=$(cat version)
    echo "Current version: $VERSION"
    IFS='.' read -ra VERSION_PARTS <<<"$VERSION"

    MAJOR=${VERSION_PARTS[0]}
    MINOR=${VERSION_PARTS[1]}
    PATCH=${VERSION_PARTS[2]}

    PS3='Enter which part to increment: '
    options=("major" "minor" "patch")
    select opt in "${options[@]}"; do
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

    echo "$NEW_VERSION" >version
    echo "Version updated to $NEW_VERSION"
}

git_push() {
    current_branch=$(git rev-parse --abbrev-ref HEAD)
    echo "Enter commit message:"
    read commit_message
    git add .
    git commit -m "$commit_message"
    git push origin $current_branch

    git tag $NEW_VERSION
    git push origin $NEW_VERSION

    echo "Changes pushed to $current_branch with tag $NEW_VERSION"
}

if [[ $1 == "version" ]]; then
    increment_version
elif [[ $1 == "push" ]]; then
    git_push
elif [[ $1 == "deploy" ]]; then
    increment_version
    git_push
else
    echo "Usage: ./commit.sh [version|push|deploy]"
fi