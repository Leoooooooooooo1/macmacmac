#!/bin/bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
PYTHON_BIN="${PYTHON_BIN:-python3.13}"

if ! command -v "$PYTHON_BIN" >/dev/null 2>&1; then
  echo "未找到 $PYTHON_BIN。请安装 Python 3.13，并重新运行。"
  exit 1
fi

build_one() {
  local dir="$1"
  local name="$2"
  cd "$ROOT/$dir"
  "$PYTHON_BIN" -m venv .venv
  . .venv/bin/activate
  python -m pip install --upgrade pip
  python -m pip install -r requirements.txt
  if [ "$name" = "三网市调助手" ]; then
    python -m playwright install chromium
  fi
  rm -rf build dist
  python -m PyInstaller --noconfirm --clean --windowed --name "$name" launcher.py
  deactivate
  echo "已生成：$ROOT/$dir/dist/$name.app"
}

build_one "周月计划处理助手" "周月计划处理助手"
build_one "三网市调助手" "三网市调助手"
echo "两个 macOS 应用已构建完成。"
