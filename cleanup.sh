#!/usr/bin/env zsh
# 이전 버전 제거 스크립트 (csw, claude-switch → claude-account)

ZSHRC="${HOME}/.zshrc"

echo "=== 이전 버전 제거 ==="
echo ""

# ── 구버전 바이너리 제거 ──────────────────────────────────────────────────────
for old_bin in "/usr/local/bin/csw"; do
  if [[ -f "${old_bin}" ]]; then
    sudo rm -f "${old_bin}"
    echo "✓ ${old_bin} 제거 완료"
  fi
done

# ── 구버전 설치 파일 제거 ─────────────────────────────────────────────────────
for old_file in "${HOME}/.claude-switch.sh"; do
  if [[ -f "${old_file}" ]]; then
    rm -f "${old_file}"
    echo "✓ ${old_file} 제거 완료"
  fi
done

# ── ~/.zshrc 에서 이전 마커 블록 제거 ────────────────────────────────────────
for old_marker in "# claude-switch" "# csw"; do
  if grep -qF "${old_marker}" "${ZSHRC}"; then
    sed -i '' "/^${old_marker}$/{N;d;}" "${ZSHRC}"
    echo "✓ ~/.zshrc '${old_marker}' 블록 제거 완료"
  fi
done

echo ""
echo "완료. 이제 install.sh 를 실행하세요:"
echo "  ./install.sh"
