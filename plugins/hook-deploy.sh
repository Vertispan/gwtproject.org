#!/usr/bin/env bash

# Show us commands, stop on errors, and fail on missing vars
set -eux

# Remove any leftovers from past builds
rm -rf -- /deploy

# Start in a fresh directory
mkdir /deploy
cd /deploy

curl -L -o repo.zip https://nightly.link/gwt-plugins/gwt-eclipse-plugin/workflows/build/main/repository.zip

cd /nightly

rm -rf *

unzip /deploy/repo.zip