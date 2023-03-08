#!/usr/bin/env sh

# Show us commands, stop on errors, and fail on missing vars
set -eux

# Remove any leftovers from past builds
rm -rf -- /deploy

# Start in a fresh directory
mkdir /deploy
cd /deploy

curl -L -o repo.zip https://nightly.link/gwt-plugins/gwt-eclipse-plugin/workflows/build/main/repository.zip

cd /gwt-eclipse-plugin

DIR="nightly-$(date +%F-%_H-%M-%S)"

mkdir "$DIR"
cd "$DIR"

unzip /deploy/repo.zip

cd ..

# Before we replace the soft link, track what it points to
OLD_DIR=$(realpath nightly)

# Create a soft link to the new directory
ln -s -f -n "$DIR" nightly

# Delete the old deployment
rm -rf "$OLD_DIR"
