#!/bin/bash
# =============================================================================
# Aurora Machine Setup — Backup Drive + Syncthing
# Run after a fresh Aurora install or home restore
# Usage: sudo bash setup.sh
# =============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

bold()  { echo -e "\033[1m$*\033[0m"; }
green() { echo -e "\033[32m$*\033[0m"; }
yellow(){ echo -e "\033[33m$*\033[0m"; }
red()   { echo -e "\033[31m$*\033[0m"; }

die() { red "ERROR: $*"; exit 1; }

[ "$(id -u)" -eq 0 ] || die "Run with sudo: sudo bash $0"

REAL_USER="${SUDO_USER:-joey}"
REAL_HOME=$(eval echo "~$REAL_USER")

echo ""
bold "========================================="
bold "  Aurora Machine Setup"
bold "========================================="
echo ""

# =============================================================================
# 1. BACKUP DRIVE SETUP
# =============================================================================
bold "[1/2] Backup Drive Setup"
echo "─────────────────────────────────────────"

# Install backup + restore scripts
cp "$SCRIPT_DIR/backup-to-portable" /usr/local/bin/backup-to-portable
cp "$SCRIPT_DIR/restore-from-portable" /usr/local/bin/restore-from-portable
chmod 755 /usr/local/bin/backup-to-portable /usr/local/bin/restore-from-portable
green "  ✓ Installed backup/restore scripts to /usr/local/bin/"

# Install systemd service
cp "$SCRIPT_DIR/backup-portable.service" /etc/systemd/system/backup-portable.service
systemctl daemon-reload
systemctl enable backup-portable.service
green "  ✓ Installed and enabled backup-portable.service"

# Install udev rule
cp "$SCRIPT_DIR/99-backup-portable.rules" /etc/udev/rules.d/99-backup-portable.rules
udevadm control --reload-rules
green "  ✓ Installed udev auto-backup rule"

# Generate LUKS keyfile if not present
if [ ! -f /etc/backup-drive.key ]; then
    dd if=/dev/urandom of=/etc/backup-drive.key bs=4096 count=1 2>/dev/null
    chmod 400 /etc/backup-drive.key
    green "  ✓ Generated new LUKS keyfile at /etc/backup-drive.key"
    echo ""
    yellow "  ⚠ New keyfile generated — you need to add it to the backup drive:"
    echo "    1. Plug in the backup drive"
    echo "    2. sudo cryptsetup luksAddKey /dev/sdX1 /etc/backup-drive.key"
    echo "       (Enter your existing passphrase when prompted)"
    echo ""
else
    green "  ✓ LUKS keyfile already exists at /etc/backup-drive.key"
fi

# Create snapshots directory on source BTRFS
BTRFS_DEVICE=$(findmnt -n -o SOURCE /var/home | sed 's/\[.*//') 
if [ -n "$BTRFS_DEVICE" ]; then
    mkdir -p /mnt/btrfs-root
    mount -o subvolid=5 "$BTRFS_DEVICE" /mnt/btrfs-root 2>/dev/null || true
    if mountpoint -q /mnt/btrfs-root; then
        mkdir -p /mnt/btrfs-root/snapshots
        green "  ✓ Snapshot directory ready on source BTRFS"
        umount /mnt/btrfs-root
    fi
fi

# Create BTRFS subvolumes for excluded paths (if not already subvolumes)
create_exclude_subvol() {
    local path="$1"
    local full_path="$REAL_HOME/$path"

    # Skip if path doesn't exist or is already a subvolume
    [ -d "$full_path" ] || return 0
    if btrfs subvolume show "$full_path" &>/dev/null; then
        green "  ✓ $path already a BTRFS subvolume (excluded from snapshots)"
        return 0
    fi

    yellow "  Converting $path to BTRFS subvolume (excludes from backup snapshots)..."
    mv "$full_path" "${full_path}.setup-bak"
    btrfs subvolume create "$full_path"
    cp -a "${full_path}.setup-bak/." "$full_path/" 2>/dev/null || true
    chown "$REAL_USER:$REAL_USER" "$full_path"
    rm -rf "${full_path}.setup-bak"
    green "  ✓ $path → BTRFS subvolume"
}

create_exclude_subvol ".cache"
create_exclude_subvol ".local/share/containers"

echo ""

# =============================================================================
# 2. SYNCTHING SETUP
# =============================================================================
bold "[2/2] Syncthing Setup"
echo "─────────────────────────────────────────"

HPSERVER_ID="5JLI4YY-6TKV3VM-ZJ6J3HT-J3P5UBX-ZCO7OUN-REF4O2P-XHZPI6B-4SNFAAU"

# Install .stignore
cp "$SCRIPT_DIR/.stignore" "$REAL_HOME/.stignore"
chown "$REAL_USER:$REAL_USER" "$REAL_HOME/.stignore"
green "  ✓ Installed .stignore"

# Check if syncthing is available
SYNCTHING_BIN=""
if command -v syncthing &>/dev/null; then
    SYNCTHING_BIN="syncthing"
elif [ -x /home/linuxbrew/.linuxbrew/bin/syncthing ]; then
    SYNCTHING_BIN="/home/linuxbrew/.linuxbrew/bin/syncthing"
fi

if [ -z "$SYNCTHING_BIN" ]; then
    yellow "  Syncthing not installed. Installing via brew..."
    if command -v brew &>/dev/null; then
        sudo -u "$REAL_USER" brew install syncthing
        SYNCTHING_BIN="/home/linuxbrew/.linuxbrew/bin/syncthing"
    elif sudo -u "$REAL_USER" bash -c 'command -v brew' &>/dev/null; then
        sudo -u "$REAL_USER" brew install syncthing
        SYNCTHING_BIN="/home/linuxbrew/.linuxbrew/bin/syncthing"
    else
        yellow "  ⚠ Homebrew not found. Install syncthing manually:"
        echo "    brew install syncthing"
        echo "    Then re-run this script, or manually:"
        echo "    brew services start syncthing"
        echo "    syncthing cli config devices add --device-id $HPSERVER_ID --name hpserver"
        echo "    syncthing cli config devices $HPSERVER_ID addresses add tcp://vgm.joeypayne.com:22000"
        echo "    syncthing cli config folders add --id home-sync --label Home --path ~/"
        echo "    syncthing cli config folders home-sync devices add --device-id $HPSERVER_ID"
        echo ""
        bold "Backup setup complete. Syncthing needs manual install."
        exit 0
    fi
fi

green "  ✓ Syncthing found: $($SYNCTHING_BIN --version | head -1)"

# Start syncthing as user if not running
if ! sudo -u "$REAL_USER" systemctl --user is-active syncthing.service &>/dev/null && \
   ! sudo -u "$REAL_USER" systemctl --user is-active homebrew.syncthing.service &>/dev/null; then
    yellow "  Starting syncthing..."
    sudo -u "$REAL_USER" brew services start syncthing 2>/dev/null || \
    sudo -u "$REAL_USER" systemctl --user enable --now syncthing.service 2>/dev/null || \
    yellow "  ⚠ Could not auto-start syncthing. Run: brew services start syncthing"
    sleep 3
fi
green "  ✓ Syncthing running"

# Configure: add hpserver device + home folder share
sudo -u "$REAL_USER" "$SYNCTHING_BIN" cli config devices add \
    --device-id "$HPSERVER_ID" --name "hpserver" 2>/dev/null || true

# Add explicit address so hpserver is reachable from anywhere (not just LAN)
sudo -u "$REAL_USER" "$SYNCTHING_BIN" cli config devices "$HPSERVER_ID" addresses add \
    "tcp://vgm.joeypayne.com:22000" 2>/dev/null || true

sudo -u "$REAL_USER" "$SYNCTHING_BIN" cli config folders add \
    --id "home-sync" --label "Home" --path "$REAL_HOME" 2>/dev/null || true

sudo -u "$REAL_USER" "$SYNCTHING_BIN" cli config folders "home-sync" devices add \
    --device-id "$HPSERVER_ID" 2>/dev/null || true

green "  ✓ Syncthing configured: home-sync → hpserver"

# Get this device's ID for pairing on hpserver
LOCAL_ID=$(sudo -u "$REAL_USER" "$SYNCTHING_BIN" cli config devices list 2>/dev/null | head -1)
echo ""
yellow "  ⚠ If this is a NEW machine, add it to hpserver:"
echo "    ssh hpserver \"syncthing cli config devices add --device-id '$LOCAL_ID' --name 'NEW-MACHINE-NAME'\""
echo "    ssh hpserver \"syncthing cli config folders home-sync devices add --device-id '$LOCAL_ID'\""

# =============================================================================
# DONE
# =============================================================================
echo ""
bold "========================================="
green "  Setup complete!"
bold "========================================="
echo ""
echo "  Backup:"
echo "    • Plug in Seagate Portable → backup runs automatically"
echo "    • Notification when safe to unplug"
echo "    • Restore: sudo restore-from-portable"
if [ ! -f /etc/backup-drive.key ] || [ "$(stat -c%s /etc/backup-drive.key 2>/dev/null)" = "4096" ]; then
    echo "    • Remember to add keyfile to drive if this is a new machine"
fi
echo ""
echo "  Sync:"
echo "    • Syncthing syncs home → hpserver whenever online"
echo "    • Excludes: caches, containers, downloads, browser data, AI logs"
echo "    • Web UI: http://127.0.0.1:8384"
echo ""
