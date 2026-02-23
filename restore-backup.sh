#!/bin/bash
# Restore from Portable backup drive on a fresh Aurora install
# Finds the drive, opens LUKS, mounts, and runs the restore script
set -euo pipefail

bold()  { echo -e "\033[1m$*\033[0m"; }
red()   { echo -e "\033[31m$*\033[0m"; }
green() { echo -e "\033[32m$*\033[0m"; }

die() { red "ERROR: $*"; exit 1; }

[ "$(id -u)" -eq 0 ] || die "Run with sudo: sudo bash restore-backup.sh"

LUKS_NAME="backup-drive"
MOUNT="/mnt/backup-drive"

# --- Find the drive ---
# Try stable by-id path first (Seagate Portable), fall back to scanning for LUKS partitions
DEVICE=""
for dev in /dev/disk/by-id/usb-Seagate_Portable_NT3D9HDX-*-part1; do
    [ -e "$dev" ] && DEVICE="$dev" && break
done

if [ -z "$DEVICE" ]; then
    bold "Seagate Portable not found by ID. Scanning for LUKS partitions..."
    for part in /dev/sd?1 /dev/nvme?n1p?; do
        [ -b "$part" ] || continue
        if cryptsetup isLuks "$part" 2>/dev/null; then
            echo "  Found LUKS partition: $part"
            DEVICE="$part"
            break
        fi
    done
fi

[ -n "$DEVICE" ] || die "No backup drive found. Plug it in and try again."
bold "Using device: $DEVICE"

# --- Open LUKS ---
if [ ! -e "/dev/mapper/$LUKS_NAME" ]; then
    echo ""
    bold "Enter your backup drive passphrase:"
    cryptsetup luksOpen "$DEVICE" "$LUKS_NAME" || die "Failed to unlock drive"
fi
green "LUKS unlocked."

# --- Mount ---
mkdir -p "$MOUNT"
if ! mountpoint -q "$MOUNT"; then
    mount /dev/mapper/"$LUKS_NAME" "$MOUNT" || die "Failed to mount"
fi
green "Mounted at $MOUNT"

# --- Verify it's a backup drive ---
if [ ! -d "$MOUNT/backups" ] || [ ! -f "$MOUNT/restore.sh" ]; then
    die "Drive doesn't look like a backup drive (missing backups/ or restore.sh)"
fi

echo ""
green "Backup drive ready."
bold "Launching restore menu..."
echo ""

# --- Run restore ---
bash "$MOUNT/restore.sh"
