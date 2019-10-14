#!/usr/bin/env sh

# stop on error
set -e

# make sure the following env variables are set
[ -z "$IMAGE_TAG" ] && { echo "$IMAGE_TAG not set"; exit 1; }
[ -z "$KEEL_WEBHOOK_URL" ] && { echo "$KEEL_WEBHOOK_URL not set"; exit 1; }
[ -z "$KEEL_USERNAME" ] && { echo "$KEEL_USERNAME not set"; exit 1; }
[ -z "$KEEL_PASSWORD" ] && { echo "$KEEL_PASSWORD not set"; exit 1; }

for image in "$@"
do
  curl --header "Content-Type: application/json" \
    --request POST \
    --data "{\"name\": \"$image\", \"tag\": \"$IMAGE_TAG\"}" \
    --user "$KEEL_USERNAME:$KEEL_PASSWORD" \
    "$KEEL_WEBHOOK_URL/v1/webhooks/native"
done