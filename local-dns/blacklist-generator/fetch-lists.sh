#!/bin/bash

SOURCES=(
  "https://v.firebog.net/hosts/lists.php?type=tick"
  "https://v.firebog.net/hosts/lists.php?type=adult"
)

OUTPUT="blocklists.txt"
TEMP=$(mktemp)

for source in "${SOURCES[@]}"; do
  echo "Fetching: $source"
  curl -sf --max-time 10 "$source" >> "$TEMP"
  if [ $? -ne 0 ]; then
    echo "ERROR: Failed to fetch $source" >&2
  fi
done

sort -u "$TEMP" > "$OUTPUT"
rm -f "$TEMP"

echo "Done. $(wc -l < "$OUTPUT") lists saved to $OUTPUT"
