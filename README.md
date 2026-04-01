# claude-account

[![macOS](https://img.shields.io/badge/macOS-zsh-blue?style=flat-square)](https://www.apple.com/macos/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow?style=flat-square)](LICENSE)

Per-project & global account isolation for [Claude Code](https://github.com/anthropics/claude-code). Switch between multiple Claude accounts instantly — pin accounts to projects so the right credentials are always used automatically.

**[한국어](README.ko.md)**

<!-- TODO: replace with actual gif -->
<!-- ![demo](demo.gif) -->

## Get started

1. Install claude-account:

   **Homebrew (recommended):**
   ```bash
   brew tap hunheelee/claude-account
   brew install claude-account
   ```

   **Manual:**
   ```bash
   git clone https://github.com/hunheelee/claude-account.git
   cd claude-account && ./install.sh
   ```

2. Apply to your current shell:

   ```bash
   source ~/.zshrc
   ```

3. Run `claude account` to switch accounts.

## Usage

```bash
claude account            # Switch the default account (interactive picker)
claude account add        # Log in and save a new account
claude account delete     # Remove a saved account
claude account pin        # Pin an account to the current project
claude account status     # Show current account info
```

Everything else passes through to the real `claude` binary as usual.

### Pin an account to a project

```bash
cd ~/work/my-project
claude account pin        # select an account to pin
```

This writes a `.claude-account` file in the project root. Any `claude` invocation inside this directory tree will use the pinned account automatically, regardless of the global default. The file is discovered by walking up from the current directory, so it works from any subdirectory.

## How it works

`claude-account` wraps the `claude` CLI with a thin shell function that overrides `$HOME` at launch, pointing Claude at a dedicated credential directory per account. No credential files are shared between accounts.

```
~/.claude-accounts/
  personal/          # credentials for "personal"
  work/              # credentials for "work"
  .current           # active global default
  .pins/work         # project paths pinned to "work"

~/.claude-homes/
  personal/.claude → ~/.claude-accounts/personal  (symlink)
  work/.claude     → ~/.claude-accounts/work      (symlink)
```

On every `claude` invocation, the wrapper:

1. Looks for a `.claude-account` file in the current directory (and parents)
2. Falls back to the global default in `~/.claude-accounts/.current`
3. Sets `HOME` to the matching stub directory, then launches `claude`

## Requirements

- macOS (zsh)
- [Claude Code CLI](https://github.com/anthropics/claude-code)
- [gum](https://github.com/charmbracelet/gum) — installed automatically if missing

## Uninstall

```bash
# Homebrew
brew uninstall claude-account

# Manual
sed -i '' '/^# claude-account$/,+1d' ~/.zshrc
rm -f ~/.claude-account.sh

# Remove saved accounts (optional)
rm -rf ~/.claude-accounts ~/.claude-homes
```

## License

MIT
