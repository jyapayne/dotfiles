#!/usr/bin/env bash
set -euo pipefail

REPO="https://github.com/Dammyjay93/interface-design.git"
SKILL_DIR="${HOME}/.config/opencode/skills/interface-design"
CMD_DIR="${HOME}/.config/opencode/commands"
TMP_DIR=$(mktemp -d)

cleanup() { rm -rf "$TMP_DIR"; }
trap cleanup EXIT

echo "Installing interface-design skill for opencode..."

# Clone latest
git clone --depth 1 --quiet "$REPO" "$TMP_DIR" 2>/dev/null || {
  echo "Error: Failed to clone $REPO" >&2
  exit 1
}

# Create directories
mkdir -p "$SKILL_DIR/references" "$SKILL_DIR/reference/examples" "$CMD_DIR"

# Install skill files
cp "$TMP_DIR/.claude/skills/interface-design/SKILL.md" "$SKILL_DIR/"
cp "$TMP_DIR/.claude/skills/interface-design/references/"*.md "$SKILL_DIR/references/"
cp "$TMP_DIR/reference/system-template.md" "$SKILL_DIR/reference/"
cp "$TMP_DIR/reference/examples/"*.md "$SKILL_DIR/reference/examples/"

# Install commands, fixing the relative path to skill
for cmd in "$TMP_DIR/.claude/commands/"*.md; do
  filename=$(basename "$cmd")
  sed 's|\.\./skills/interface-design/SKILL\.md|~/.config/opencode/skills/interface-design/SKILL.md|g' \
    "$cmd" > "$CMD_DIR/$filename"
done

echo "Done. Installed to:"
echo "  Skill:    $SKILL_DIR/"
echo "  Commands: $CMD_DIR/"
echo ""
echo "Restart opencode to pick up changes."
