#!/usr/bin/env zsh
# claude-account 로컬 설치 스크립트

set -e

SCRIPT_DIR="$(cd "$(dirname "${(%):-%x}")" && pwd)"
SOURCE_FILE="${SCRIPT_DIR}/claude-account.sh"
INSTALL_PATH="${HOME}/.claude-account.sh"
ZSHRC="${HOME}/.zshrc"
MARKER="# claude-account"
CSW_ACCOUNTS="${HOME}/.claude-accounts"
CSW_HOMES="${HOME}/.claude-homes"
CLAUDE_DIR="${HOME}/.claude"

echo "=== claude-account 설치 ==="
echo ""

# ── 1. 소스 파일 확인 ─────────────────────────────────────────────────────────
if [[ ! -f "${SOURCE_FILE}" ]]; then
  echo "오류: claude-account.sh 파일을 찾을 수 없습니다. (${SCRIPT_DIR})"
  exit 1
fi

# ── 2. ~/.claude-account.sh 로 복사 ──────────────────────────────────────────
cp "${SOURCE_FILE}" "${INSTALL_PATH}"
chmod +x "${INSTALL_PATH}"
echo "✓ ${INSTALL_PATH} 설치 완료"

# ── 3. 런타임 디렉토리 생성 ───────────────────────────────────────────────────
mkdir -p "${CSW_ACCOUNTS}"
mkdir -p "${CSW_HOMES}"
echo "✓ 런타임 디렉토리 준비 완료"

# ── 4. gum 설치 확인 ─────────────────────────────────────────────────────────
if command -v gum &>/dev/null; then
  echo "✓ gum 이미 설치되어 있습니다"
else
  echo "→ gum이 설치되어 있지 않습니다. 자동 설치를 시작합니다..."
  if command -v brew &>/dev/null; then
    brew install gum && echo "✓ gum 설치 완료"
  else
    echo "오류: Homebrew가 없습니다. 먼저 Homebrew를 설치한 후 다시 실행하세요."
    exit 1
  fi
fi

# ── 5. ~/.zshrc source 추가 (중복 방지) ──────────────────────────────────────
if [[ ! -f "${ZSHRC}" ]]; then
  touch "${ZSHRC}"
fi

if grep -qF "${MARKER}" "${ZSHRC}"; then
  echo "✓ ~/.zshrc 이미 설정되어 있습니다 (건너뜀)"
else
  printf "\n%s\nsource %s\n" "${MARKER}" "${INSTALL_PATH}" >> "${ZSHRC}"
  echo "✓ ~/.zshrc 에 source 라인 추가 완료"
fi

# ── 6. 기존 Claude 계정 자동 감지 및 초기 스냅샷 저장 ────────────────────────
CSW_CURRENT="${CSW_ACCOUNTS}/.current"

if [[ -d "${CLAUDE_DIR}" && ! -f "${CSW_CURRENT}" ]]; then
  echo ""
  printf "기존 Claude 계정이 감지되었습니다. 저장할 이름을 입력하세요 (기본값: default): "
  read -r init_name
  init_name=$(echo "${init_name}" | tr -d '[:space:]')
  [[ -z "${init_name}" ]] && init_name="default"

  cp -r "${CLAUDE_DIR}" "${CSW_ACCOUNTS}/${init_name}"
  mkdir -p "${CSW_HOMES}/${init_name}"
  ln -sf "${CSW_ACCOUNTS}/${init_name}" "${CSW_HOMES}/${init_name}/.claude"
  echo "${init_name}" > "${CSW_CURRENT}"
  echo "✓ 기존 계정을 '${init_name}'(으)로 저장했습니다."
fi

# ── 완료 ──────────────────────────────────────────────────────────────────────
echo ""
echo "=== 설치 완료 ==="
echo ""
echo "아래 명령어로 적용하세요:"
echo "  source ~/.zshrc"
echo ""
echo "사용법:"
echo "  claude account          계정 목록 및 전환"
echo "  claude account add      새 계정 추가"
echo "  claude account pin      이 프로젝트에 계정 고정"
echo "  claude account status   현재 계정 확인"
