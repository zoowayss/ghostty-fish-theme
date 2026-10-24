#!/usr/bin/env bash
# Ghostty + fish + Starship 主题一键安装（macOS）
#
# 本地运行:   bash install.sh
# 远程一键:   curl -fsSL https://raw.githubusercontent.com/<user>/ghostty-fish-theme/main/install.sh | bash
#
# 可选: 加 --set-default-shell 把 fish 设为默认 shell

set -euo pipefail

REPO="${THEME_REPO:-https://github.com/zoowayss/ghostty-fish-theme.git}"
SET_DEFAULT_SHELL=0
for arg in "$@"; do
  [[ "$arg" == "--set-default-shell" ]] && SET_DEFAULT_SHELL=1
done

info() { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33mwarn:\033[0m %s\n' "$*"; }
die()  { printf '\033[1;31merror:\033[0m %s\n' "$*" >&2; exit 1; }

[[ "$(uname -s)" == "Darwin" ]] || die "本脚本只支持 macOS"
command -v brew >/dev/null || die "未找到 Homebrew，请先安装: https://brew.sh"

# ---------- 定位主题文件：本地仓库 或 临时 clone ----------
SRC="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" 2>/dev/null && pwd || true)"
if [[ -z "$SRC" || ! -f "$SRC/ghostty/config" ]]; then
  info "下载主题文件: $REPO"
  TMP="$(mktemp -d)"
  trap 'rm -rf "$TMP"' EXIT
  git clone --depth 1 --quiet "$REPO" "$TMP/theme"
  SRC="$TMP/theme"
fi

# ---------- 安装依赖 ----------
install_formula() { brew list --formula "$1" >/dev/null 2>&1 || { info "brew install $1"; brew install "$1"; }; }
install_cask()    { brew list --cask    "$1" >/dev/null 2>&1 || { info "brew install --cask $1"; brew install --cask "$1"; }; }

install_formula fish
install_formula starship
if [[ -d /Applications/Ghostty.app ]]; then
  info "Ghostty 已安装"
else
  install_cask ghostty
fi

# ---------- 字体 MesloLGS NF（powerlevel10k 发布的 Nerd Font 版 Meslo）----------
FONT_DIR="$HOME/Library/Fonts"
FONT_BASE="https://github.com/romkatv/powerlevel10k-media/raw/master"
mkdir -p "$FONT_DIR"
for f in "MesloLGS NF Regular.ttf" "MesloLGS NF Bold.ttf" "MesloLGS NF Italic.ttf" "MesloLGS NF Bold Italic.ttf"; do
  if [[ -f "$FONT_DIR/$f" ]]; then
    continue
  fi
  info "下载字体 $f"
  curl -fsSL -o "$FONT_DIR/$f" "$FONT_BASE/${f// /%20}"
done

# ---------- 复制配置（已有文件先备份）----------
STAMP="$(date +%Y%m%d-%H%M%S)"
put() {  # put <src> <dst>
  local src="$1" dst="$2"
  mkdir -p "$(dirname "$dst")"
  if [[ -f "$dst" ]] && ! cmp -s "$src" "$dst"; then
    cp "$dst" "$dst.bak.$STAMP"
    warn "已备份 $dst -> $dst.bak.$STAMP"
  fi
  cp "$src" "$dst"
  info "写入 $dst"
}

put "$SRC/ghostty/config"                            "$HOME/.config/ghostty/config"
put "$SRC/starship.toml"                             "$HOME/.config/starship.toml"
put "$SRC/fish/config.fish"                          "$HOME/.config/fish/config.fish"
put "$SRC/fish/functions/fish_user_key_bindings.fish" "$HOME/.config/fish/functions/fish_user_key_bindings.fish"

# ---------- 可选：fish 设为默认 shell ----------
FISH_BIN="$(brew --prefix)/bin/fish"
if [[ "$SET_DEFAULT_SHELL" == 1 ]]; then
  grep -qx "$FISH_BIN" /etc/shells || { info "把 $FISH_BIN 加入 /etc/shells（需要 sudo）"; echo "$FISH_BIN" | sudo tee -a /etc/shells >/dev/null; }
  [[ "$SHELL" == "$FISH_BIN" ]] || { info "chsh -s $FISH_BIN"; chsh -s "$FISH_BIN"; }
fi

cat <<MSG

完成。接下来：
  1. 重新打开 Ghostty（或按 Cmd+Shift+, 重载配置）
  2. 若 fish 还不是默认 shell，可以：
       - 重新运行并加参数:  bash install.sh --set-default-shell
       - 或只在 Ghostty 里用 fish: 在 ~/.config/ghostty/config 加一行  command = $FISH_BIN
MSG
