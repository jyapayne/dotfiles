#!/usr/bin/env bash
# Kept for muscle memory: same as `./dot deploy` (see ./dot help).
exec "$(dirname -- "$(realpath -- "${BASH_SOURCE[0]}")")/dot" deploy "$@"
