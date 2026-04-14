#!/usr/bin/env zsh

ZSHRC="${HOME}/.zshrc"
# Uninstall
brew uninstall claude-account 2>/dev/null || true

# Untap
brew untap cherijs/claude-account 2>/dev/null || true

# Tap
brew tap cherijs/claude-account

# Install
brew install claude-account

SOURCE_LINE="source \"$(brew --prefix)/share/claude-account/claude-account.sh\""

# Add to zshrc (skip if already present)
if ! grep -qF "${SOURCE_LINE}" "${ZSHRC}" 2>/dev/null; then
  echo "\n# claude-account\n${SOURCE_LINE}" >> "${ZSHRC}"
fi

# Reload shell
exec zsh
