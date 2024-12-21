#!/usr/bin/env sh

# Simple script to update and replace www content. Future revisions should pull javadoc
# separately (from the latest release), and possible separate each of the three different
# content sources to let only one update at a time more quickly.

# Show us commands, stop on errors, and fail on missing vars
set -eux

# Ensure rsync is available, if not, install it with apk
if ! command -v rsync; then
  apk add rsync
fi

# Create a temp dir to do our work in
WORK_DIR=$(mktemp -d)

# Download the latest builds for gwt-site and gwt-site-webapp
curl -L -o "$WORK_DIR/gwt-site.zip" https://nightly.link/gwtproject/gwt-site/workflows/build/main/gwt-site.zip
curl -L -o "$WORK_DIR/gwt-site-webapp.zip" https://nightly.link/gwtproject/gwt-site-webapp/workflows/build/main/gwt-site-webapp.zip

# Unzip the files
mkdir "$WORK_DIR/www"
unzip "$WORK_DIR/gwt-site.zip" -d "$WORK_DIR/www"
unzip "$WORK_DIR/gwt-site-webapp.zip" -d "$WORK_DIR/www"

# Add/delete/update files as needed from the hosted directory
rsync -avh --delete "$WORK_DIR/www/" /usr/share/nginx/html/

# Clean up work directory
rm -r "$WORK_DIR"
