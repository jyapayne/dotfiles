#!/usr/bin/env bash
# Super+Shift+T: select a screenshot region and copy local Indra OCR as plain text.
set -euo pipefail

# Keep the existing slurp options; cancellation leaves the clipboard untouched.
# shellcheck disable=SC2086
region="$(slurp ${SLURP_ARGS:-})" || exit 0
image="$(mktemp --suffix=.png "${TMPDIR:-/tmp}/indra-ocr.XXXXXXXXXX")"
trap 'rm -f -- "$image"' EXIT

grim -g "$region" "$image"
text="$("$HOME/.local/bin/indra-ocr" "$image" --format text --cores 4)"
printf '%s' "$text" | wl-copy
