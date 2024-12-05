#!/usr/bin/env sh

# Webhook handler to download and deploy the latest nightly build of the GWT Eclipse Plugin itself.
# Doesn't handle GWT SDKs, and assumes we always want the latest. Should only be called when main
# has been successfully built in CI, and an artifact is available.

# Show us commands, stop on errors, and fail on missing vars
set -eux

# Create a temp dir to do our work in
WORK_DIR=$(mktemp -d)

cd "$WORK_DIR"

# Download the latest nightly build, always named repository.zip
curl -L -o repo.zip https://nightly.link/gwt-plugins/gwt-eclipse-plugin/workflows/build/main/repository.zip

cd /plugins/gwt-eclipse-plugin

# Create a new directory to unzip the nightly build into
DIR="nightly-$(date +%F-%_H-%M-%S)"

mkdir "$DIR"
cd "$DIR"

unzip "$WORK_DIR/repo.zip"

cd ..

# Before we replace the soft link, track what it points to
OLD_DIR=$(realpath nightly)

# Create a soft link to the new directory
ln -s -f -n "$DIR" nightly

# Delete the old deployment and downloaded zip
rm -r "$OLD_DIR"
rm -r "$WORK_DIR"
