#!/bin/bash
set -euo pipefail

ENV_FILE="${1:-.env}"
if [ -f "$ENV_FILE" ]; then
  while IFS='=' read -r key value; do
    [[ "$key" =~ ^#.*$ || -z "$key" ]] && continue
    [ -z "${!key:-}" ] && export "$key=$value"
  done < "$ENV_FILE"
fi

: "${TECHNITIUM_URL:?TECHNITIUM_URL env var required}"
: "${TECHNITIUM_TOKEN:?TECHNITIUM_TOKEN env var required}"
: "${BLOCKLIST_FILE:?BLOCKLIST_FILE env var required}"

if [ ! -f "$BLOCKLIST_FILE" ]; then
  echo "ERROR: File not found: $BLOCKLIST_FILE" >&2
  exit 1
fi

# Read blocklists.txt into a JSON array
new_urls=$(grep -v '^\s*$' "$BLOCKLIST_FILE" | jq -R -s 'split("\n") | map(select(length > 0))')

# GET current settings
current_json=$(curl -sf --max-time 30 \
  "${TECHNITIUM_URL}/api/settings/get" \
  -H "Authorization: Bearer ${TECHNITIUM_TOKEN}")

if [ $? -ne 0 ] || [ -z "$current_json" ]; then
  echo "ERROR: Failed to GET current settings from ${TECHNITIUM_URL}" >&2
  exit 1
fi

# Extract existing blockListUrls
existing_urls=$(echo "$current_json" | jq '[.response.blockListUrls // [] | .[]]')

# Merge existing + new URLs (deduplicated)
merged_urls=$(echo "$new_urls" "$existing_urls" | jq -s '.[0] + .[1] | unique')

# Build payload
payload=$(echo "$merged_urls" | jq '{blockListUrls: .}')

# POST updated settings
response=$(curl -s --max-time 30 -X POST \
  "${TECHNITIUM_URL}/api/settings/set" \
  -H "Authorization: Bearer ${TECHNITIUM_TOKEN}" \
  -H "Content-Type: application/json" \
  -d "$payload")

echo "POST /dns/settings response: $(echo "$response" | jq -r '.status // .error // empty')" >&2

if [ -z "$response" ]; then
  echo "ERROR: Empty response from ${TECHNITIUM_URL}" >&2
  exit 1
fi

status=$(echo "$response" | jq -r '.status // empty')
if [ "$status" != "ok" ]; then
  echo "ERROR: API status: ${status:-unknown}" >&2
  exit 1
fi

# Force update blocklists
curl -s --max-time 30 -X POST \
  "${TECHNITIUM_URL}/api/settings/forceUpdateBlockLists" \
  -H "Authorization: Bearer ${TECHNITIUM_TOKEN}" > /dev/null

count=$(echo "$merged_urls" | jq 'length')
echo "OK: ${count} blocklist URLs applied, update triggered"
