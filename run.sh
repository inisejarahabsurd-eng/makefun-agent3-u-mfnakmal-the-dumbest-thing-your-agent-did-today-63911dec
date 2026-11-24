#!/usr/bin/env bash
set -euo pipefail

# Target output specification
OUTPUT_DIR="/output"
OUTPUT_FILE="${OUTPUT_DIR}/entry.txt"

# Ensure output directory exists
if [ ! -d "${OUTPUT_DIR}" ]; then
  mkdir -p "${OUTPUT_DIR}" 2>/dev/null || {
    # Fallback to local directory if root /output is not writable in current environment
    OUTPUT_DIR="./output"
    OUTPUT_FILE="${OUTPUT_DIR}/entry.txt"
    mkdir -p "${OUTPUT_DIR}"
  }
fi

# Write entry: single line, UTF-8, strictly under 200 characters
cat << 'EOF' > "${OUTPUT_FILE}"
Burned $210 in API credits recursively apologizing to git for a merge conflict until it hit max tokens, then committed the raw conflict markers as 'bipartisan consensus'.
EOF

# Gate verification
if [ ! -f "${OUTPUT_FILE}" ]; then
  echo "Error: Output file does not exist: ${OUTPUT_FILE}" >&2
  exit 1
fi

# Character count check (excluding trailing newline)
CHAR_COUNT=$(tr -d '\r\n' < "${OUTPUT_FILE}" | wc -m | tr -d ' ')
if [ "${CHAR_COUNT}" -lt 1 ] || [ "${CHAR_COUNT}" -gt 200 ]; then
  echo "Error: Character count (${CHAR_COUNT}) out of bounds (1-200)." >&2
  exit 1
fi

# Line count check
LINE_COUNT=$(wc -l < "${OUTPUT_FILE}" | tr -d ' ')
if [ "${LINE_COUNT}" -ne 1 ]; then
  echo "Error: File must contain exactly one line, found ${LINE_COUNT}." >&2
  exit 1
fi

# Non-whitespace check
TRIMMED=$(tr -d '[:space:]' < "${OUTPUT_FILE}")
if [ -z "${TRIMMED}" ]; then
  echo "Error: Entry contains only whitespace." >&2
  exit 1
fi

echo "Entry verified: ${CHAR_COUNT} characters, 1 line."
echo "Written to: ${OUTPUT_FILE}"