#!/usr/bin/env zsh
# Remove previous versions (csw, claude-switch → claude-account)

ZSHRC="${HOME}/.zshrc"

echo "=== Removing previous versions ==="
echo ""

# ── Remove old binaries ──────────────────────────────────────────────────────
for old_bin in "/usr/local/bin/csw"; do
  if [[ -f "${old_bin}" ]]; then
    sudo rm -f "${old_bin}"
    echo "✓ ${old_bin} removed"
  fi
done

# ── Remove old install files ─────────────────────────────────────────────────
for old_file in "${HOME}/.claude-switch.sh"; do
  if [[ -f "${old_file}" ]]; then
    rm -f "${old_file}"
    echo "✓ ${old_file} removed"
  fi
done

# ── Remove old marker blocks from ~/.zshrc ────────────────────────────────────
for old_marker in "# claude-switch" "# csw"; do
  if grep -qF "${old_marker}" "${ZSHRC}"; then
    sed -i '' "/^${old_marker}$/{N;d;}" "${ZSHRC}"
    echo "✓ ~/.zshrc '${old_marker}' block removed"
  fi
done

echo ""
echo "Done. Now run install.sh:"
echo "  ./install.sh"
