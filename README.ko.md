# claude-account

[![macOS](https://img.shields.io/badge/macOS-zsh-blue?style=flat-square)](https://www.apple.com/macos/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow?style=flat-square)](LICENSE)

[Claude Code](https://github.com/anthropics/claude-code)를 위한 프로젝트별 & 전역 계정 격리 도구. 여러 Claude 계정을 즉시 전환하고, 프로젝트마다 계정을 고정하여 항상 올바른 인증 정보가 자동으로 사용되도록 합니다.

**[English](README.md)**

<!-- TODO: 실제 gif로 교체 -->
<!-- ![demo](demo.gif) -->

## 시작하기

1. claude-account 설치:

   **Homebrew (권장):**
   ```bash
   brew tap hunhee98/claude-account
   brew install claude-account
   ```

   **수동 설치:**
   ```bash
   git clone https://github.com/hunhee98/claude-account.git
   cd claude-account && ./install.sh
   ```

2. 현재 쉘에 적용:

   ```bash
   source ~/.zshrc
   ```

3. `claude account`를 실행하여 계정을 전환하세요.

## 사용법

```bash
claude account            # 기본 계정 전환 (인터랙티브 선택)
claude account add        # 새 계정으로 로그인 및 저장
claude account delete     # 저장된 계정 삭제
claude account pin        # 현재 프로젝트에 계정 고정
claude account status     # 현재 계정 정보 확인
```

그 외 모든 인수는 실제 `claude` 바이너리로 그대로 전달됩니다.

### 프로젝트에 계정 고정

```bash
cd ~/work/my-project
claude account pin        # 고정할 계정 선택
```

프로젝트 루트에 `.claude-account` 파일이 생성됩니다. 이후 해당 디렉토리 트리 내에서 `claude`를 실행하면 전역 기본값과 관계없이 고정된 계정이 자동으로 사용됩니다. 현재 디렉토리에서 상위로 탐색하므로, 프로젝트 하위 디렉토리 어디서든 동작합니다.

## 동작 원리

`claude-account`는 `claude` CLI를 얇은 쉘 함수로 감싸서, 실행 시 `$HOME`을 계정별 전용 인증 디렉토리로 교체합니다. 계정 간에 인증 파일이 공유되지 않습니다.

```
~/.claude-accounts/
  personal/          # "personal" 계정의 인증 정보
  work/              # "work" 계정의 인증 정보
  .current           # 현재 전역 기본 계정
  .pins/work         # "work"에 고정된 프로젝트 경로

~/.claude-homes/
  personal/.claude → ~/.claude-accounts/personal  (심볼릭 링크)
  work/.claude     → ~/.claude-accounts/work      (심볼릭 링크)
```

`claude` 실행 시 래퍼 함수가:

1. 현재 디렉토리(및 상위)에서 `.claude-account` 파일을 탐색
2. 없으면 `~/.claude-accounts/.current`의 전역 기본 계정으로 폴백
3. 해당 스텁 디렉토리로 `HOME`을 설정한 뒤 `claude` 실행

## 요구사항

- macOS (zsh)
- [Claude Code CLI](https://github.com/anthropics/claude-code)
- [gum](https://github.com/charmbracelet/gum) — 없으면 자동 설치

## 제거

```bash
# Homebrew
brew uninstall claude-account

# 수동 설치
sed -i '' '/^# claude-account$/,+1d' ~/.zshrc
rm -f ~/.claude-account.sh

# 저장된 계정 전체 삭제 (선택사항)
rm -rf ~/.claude-accounts ~/.claude-homes
```

## 라이선스

MIT
