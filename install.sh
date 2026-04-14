#!/usr/bin/env zsh
# claude-account local installation script

set -e

SCRIPT_DIR="$(cd "$(dirname "${(%):-%x}")" && pwd)"
SOURCE_FILE="${SCRIPT_DIR}/claude-account.sh"
INSTALL_PATH="${HOME}/.claude-account.sh"
ZSHRC="${HOME}/.zshrc"
MARKER="# claude-account"
CSW_ACCOUNTS="${HOME}/.claude-accounts"
CSW_HOMES="${HOME}/.claude-homes"
CLAUDE_DIR="${HOME}/.claude"

echo "=== claude-account installation ==="
echo ""

# ── 1. Check source file ─────────────────────────────────────────────────────────
if [[ ! -f "${SOURCE_FILE}" ]]; then
  echo "Error: claude-account.sh not found. (${SCRIPT_DIR})"
  exit 1
fi

# ── 2. Copy to ~/.claude-account.sh ──────────────────────────────────────────
cp "${SOURCE_FILE}" "${INSTALL_PATH}"
chmod +x "${INSTALL_PATH}"
echo "✓ ${INSTALL_PATH} installed"

# ── 3. Create runtime directories ───────────────────────────────────────────────
mkdir -p "${CSW_ACCOUNTS}"
mkdir -p "${CSW_HOMES}"
echo "✓ Runtime directories ready"

# ── 4. Check gum installation ─────────────────────────────────────────────────────
if command -v gum &>/dev/null; then
  echo "✓ gum is already installed"
else
  echo "→ gum is not installed. Starting automatic installation..."
  if command -v brew &>/dev/null; then
    brew install gum && echo "✓ gum installed"
  else
    echo "Error: Homebrew not found. Please install Homebrew first."
    exit 1
  fi
fi

# ── 5. Add source to ~/.zshrc (prevent duplicates) ──────────────────────────────
if [[ ! -f "${ZSHRC}" ]]; then
  touch "${ZSHRC}"
fi

if grep -qF "${MARKER}" "${ZSHRC}"; then
  echo "✓ ~/.zshrc already configured (skipped)"
else
  printf "\n%s\nsource %s\n" "${MARKER}" "${INSTALL_PATH}" >> "${ZSHRC}"
  echo "✓ Added source line to ~/.zshrc"
fi

# ── 6. Auto-detect existing Claude account and save initial snapshot ────────────
CSW_CURRENT="${CSW_ACCOUNTS}/.current"

if [[ -d "${CLAUDE_DIR}" && ! -f "${CSW_CURRENT}" ]]; then
  echo ""
  printf "Existing Claude account detected. Enter name to save (default: default): "
  read -r init_name
  init_name=$(echo "${init_name}" | tr -d '[:space:]')
  [[ -z "${init_name}" ]] && init_name="default"

  cp -r "${CLAUDE_DIR}" "${CSW_ACCOUNTS}/${init_name}"
  mkdir -p "${CSW_HOMES}/${init_name}"
  ln -sf "${CSW_ACCOUNTS}/${init_name}" "${CSW_HOMES}/${init_name}/.claude"
  echo "${init_name}" > "${CSW_CURRENT}"
  echo "✓ Existing account saved as '${init_name}'."
fi

# ── Done ──────────────────────────────────────────────────────────────────────
echo ""
echo "=== Installation complete ==="
echo ""
echo "Apply with:"
echo "  source ~/.zshrc"
echo ""
echo "Usage:"
echo "  claude account          Account list & switch"
echo "  claude account add      Add new account"
echo "  claude account pin      Pin account to this project"
echo "  claude account status   Show current account"
