#!/usr/bin/env sh

# Startup handler for a new deployment of the plugin container - collects all
# "currently supported" releases of the Eclipse plugins and deploys them.

# Show us commands, stop on errors, and fail on missing vars
set -eux

# Ask GitHub for all GPE releases, filter as selected, and iterate through download urls
curl https://api.github.com/repos/gwt-plugins/gwt-eclipse-plugin/releases \
    | jq '.[] | select(.tag_name >= "v4.0") | .assets[0].browser_download_url' \
    | xargs -n1 /scripts/deploy-release.sh gwt-eclipse-plugin

# Ask GitHub for all SDK releases, iterate through download urls
curl https://api.github.com/repos/gwt-plugins/gwt-sdk-plugins/releases \
    | jq '.[].assets[0].browser_download_url' \
    | xargs -n1 /scripts/deploy-release.sh gwt-sdk-plugin
