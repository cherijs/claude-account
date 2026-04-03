#!/usr/bin/env zsh

ZSHRC="${HOME}/.zshrc"
# 삭제
brew uninstall claude-account 2>/dev/null || true

# 언탭
brew untap hunhee98/claude-account 2>/dev/null || true

# 탭
brew tap hunhee98/claude-account

# 설치
brew install claude-account

SOURCE_LINE="source \"$(brew --prefix)/share/claude-account/claude-account.sh\""

# zshrc에 경로 추가 (이미 있으면 생략)
if ! grep -qF "${SOURCE_LINE}" "${ZSHRC}" 2>/dev/null; then
  echo "\n# claude-account\n${SOURCE_LINE}" >> "${ZSHRC}"
fi

# 소스 갱신
exec zsh
