#!/usr/bin/env bash
# Kept for muscle memory: same as `./dot backup` (see ./dot help).
exec "$(dirname -- "$(realpath -- "${BASH_SOURCE[0]}")")/dot" backup "$@"
