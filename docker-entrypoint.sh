#!/bin/bash
set -euo pipefail

OBSIDIAN=/opt/obsidian/obsidian

# Always set writable home directory so Obsidian doesn't try to write
# config/logs into the read-only install directory
ARGS=()

if ! echo "$@" | grep -q -- '--home'; then
    ARGS+=(--home /home/obsidian)
fi

if ! echo "$@" | grep -q -- '--log'; then
    ARGS+=(--log /wads/LOGS.txt)
fi

# If a config file is mounted at /config/CONFIG.txt, use it automatically
if [ -f /config/CONFIG.txt ] && ! echo "$@" | grep -q -- '--config'; then
    ARGS+=(--config /config/CONFIG.txt)
fi

# If an options file is mounted at /config/OPTIONS.txt, use it automatically
if [ -f /config/OPTIONS.txt ] && ! echo "$@" | grep -q -- '--options'; then
    ARGS+=(--options /config/OPTIONS.txt)
fi

# Support shorthand subcommands for convenience
case "${1:-}" in
    help)
        exec "$OBSIDIAN" "${ARGS[@]}" --help
        ;;
    printref)
        shift
        exec "$OBSIDIAN" "${ARGS[@]}" --printref "$@"
        ;;
    printref-json)
        shift
        exec "$OBSIDIAN" "${ARGS[@]}" --printref-json "$@"
        ;;
    *)
        # Pass everything directly to obsidian
        exec "$OBSIDIAN" "${ARGS[@]}" "$@"
        ;;
esac
