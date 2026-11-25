#!/bin/bash
# Re-apply monitor rules for currently connected monitors only.
# Skips entries for disconnected monitors and the fallback rule to avoid flickering.

config="$HOME/.config/hypr/monitors-persistent.conf"

if [ ! -f "$config" ]; then
  exit 0
fi

sleep 0.3

# Get descriptions of currently connected monitors
connected=$(hyprctl monitors -j 2>/dev/null | grep -oP '"description"\s*:\s*"\K[^"]+')

while IFS= read -r line; do
  case "$line" in
    monitor=desc:*)
      rule="${line#monitor=}"
      # Extract the desc value (up to first comma)
      desc="${rule#desc:}"
      desc="${desc%%,*}"
      # Only apply if this monitor is actually connected
      if echo "$connected" | grep -qF "$desc"; then
        hyprctl keyword monitor "$rule" >/dev/null 2>&1
      fi
      ;;
  esac
done < "$config"
