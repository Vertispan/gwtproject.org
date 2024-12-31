#!/usr/bin/env sh

# Webhook handler for releases of a GWT SDK Plugin.
# Intended to be triggered by a GitHub release event, and will download and deploy
# the first release asset.

# Show us commands, stop on errors, and fail on missing vars
set -eux

# Read from args to get the URL we should download (from the webhook payload), and
# delegate to a script we share with init_release.sh
/scripts/deploy-release.sh gwt-sdk-plugins "$1"
