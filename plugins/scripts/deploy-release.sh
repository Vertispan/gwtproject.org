#!/usr/bin/env sh

# Shared tool to

# Show us commands, stop on errors, and fail on missing vars
set -eux

# Grab the plugin name from the first argument
PLUGIN="$1"

# If the plugin is empty, error out
if [ -z "$PLUGIN" ]; then
    echo "No plugin provided, can't deploy release"
    exit 1
fi

# If the plugin doesn't match a directory in /, error out
if [ ! -d "/plugins/$PLUGIN" ]; then
    echo "Plugin $PLUGIN not found, can't deploy release: $(ls -mQ /plugins)"
    exit 1
fi

# Grab the URL from the second argument
URL="$2"

# If the URL is empty, error out
if [ -z "$URL" ]; then
    echo "No URL provided, can't deploy release"
    exit 1
fi

# Pick out the version number from the URL. Expected pattern is:
#   Look between "/" marks, then "v" followed by a number and a dot,
#   and any other characters.
# Only match the contents between first v and the last slash.
VERSION=$(echo "$URL" |  sed -E 's/.*\/v([0-9]+\.[^\/]+)\/.*/\1/')

# If the version is empty, we failed to parse the URL
if [ -z "$VERSION" ]; then
    echo "Failed to parse version from URL: $URL"
    exit 1
fi

# If the release already exists, don't re-deploy
if [ -d "/plugins/$PLUGIN/$VERSION" ]; then
    echo "Release $VERSION already exists, skipping"
    exit 0
fi

# Make a temp work dir for the release zip
WORK_DIR=$(mktemp -d)

# Download the release zip
curl -L -o "$WORK_DIR/repo.zip" "$URL"

# Create a release directory to unpack to
mkdir -p "/plugins/$PLUGIN/$VERSION"
cd "/plugins/$PLUGIN/$VERSION"

# Unpack the release
unzip "$WORK_DIR/repo.zip"

# Clean up the downloaded zip
rm -r "$WORK_DIR"