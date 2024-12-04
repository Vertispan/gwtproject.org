#!/usr/bin/env sh

# Simple script to update and replace www content

# Show us commands, stop on errors, and fail on missing vars
set -eux

# Create a temp dir to do our work in
WORK_DIR=$(mktemp -d)

# Download the latest builds for gwt-site and gwt-site-webapp
curl -L -o "$WORK_DIR/gwt-site.zip" https://nightly.link/niloc132/gwt-site/workflows/build/github-actions/gwt-site.zip
curl -L -o "$WORK_DIR/gwt-site-webapp.zip" https://nightly.link/niloc132/gwt-site-webapp/workflows/build/github-actions/gwt-site-webapp.zip

# Unzip the files
mkdir "$WORK_DIR/www"
unzip "$WORK_DIR/gwt-site.zip" -d "$WORK_DIR/www"
unzip "$WORK_DIR/gwt-site-webapp.zip" -d "$WORK_DIR/www"

# Add/delete/update files as needed from the hosted directory
rsync -avh --delete "$WORK_DIR/www/" /usr/share/nginx/html/

# Clean up work directory
rm -r "$WORK_DIR"