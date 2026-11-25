#!/bin/bash
# Merges nwg-displays output (monitors.conf) into the persistent config.
# Keyed by desc: identifier — new entries update existing ones, unknown monitors are added.

src="$HOME/.config/hypr/monitors.conf"
dst="$HOME/.config/hypr/monitors-persistent.conf"

if [ ! -f "$src" ]; then
  exit 0
fi

# Parse new entries from nwg-displays into an associative array keyed by desc
declare -A new_entries
while IFS= read -r line; do
  case "$line" in
    monitor=desc:*)
      rule="${line#monitor=}"
      # Extract the desc key (everything up to the first comma after desc:)
      desc_key="${rule%%,*}"
      new_entries["$desc_key"]="$line"
      ;;
  esac
done < "$src"

if [ ${#new_entries[@]} -eq 0 ]; then
  exit 0
fi

# Parse existing persistent entries
declare -A existing_entries
declare -a order=()
has_fallback=false
header_lines=()

if [ -f "$dst" ]; then
  while IFS= read -r line; do
    case "$line" in
      monitor=desc:*)
        rule="${line#monitor=}"
        desc_key="${rule%%,*}"
        existing_entries["$desc_key"]="$line"
        order+=("$desc_key")
        ;;
      monitor=,*)
        has_fallback=true
        ;;
      "#"*|"")
        # Skip comments and blank lines during merge — we'll regenerate them
        ;;
    esac
  done < "$dst"
fi

# Merge: update existing entries, add new ones
for desc_key in "${!new_entries[@]}"; do
  if [ -n "${existing_entries[$desc_key]+x}" ]; then
    # Update existing
    existing_entries["$desc_key"]="${new_entries[$desc_key]}"
  else
    # Add new
    existing_entries["$desc_key"]="${new_entries[$desc_key]}"
    order+=("$desc_key")
  fi
done

# Write out the merged config
{
  echo "# Persistent monitor config — accumulated from nwg-displays runs."
  echo "# Contains desc-based entries for ALL known monitors across all locations."
  echo "# Hyprland ignores entries for monitors that aren't currently connected."
  echo "# Updated automatically by merge-monitors.sh when nwg-displays changes monitors.conf."
  echo ""
  for desc_key in "${order[@]}"; do
    echo "${existing_entries[$desc_key]}"
  done
  echo ""
  echo "# Fallback for any unrecognized monitor"
  echo "monitor=,preferred,auto,1"
} > "$dst"
