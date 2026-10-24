# ghostty-fish-theme

Ghostty + fish + Starship 终端主题，一条命令装好。

- **Ghostty**: Dracula 配色、MesloLGS NF 字体、Cmd+D/Cmd+Shift+D 分屏、Ctrl+` 全局下拉终端等快捷键
- **Starship**: Catppuccin Mocha 调色的 powerline 风格提示符（右侧显示 node/python/java/rust/go 版本）
- **fish**: 关闭欢迎语、Ctrl+L 清屏并清空滚动缓冲、Ctrl+C 回显 `^C`

## 一键安装（macOS，需要 Homebrew）

```bash
curl -fsSL https://raw.githubusercontent.com/zoowayss/ghostty-fish-theme/main/install.sh | bash
```

想顺便把 fish 设为默认 shell：

```bash
curl -fsSL https://raw.githubusercontent.com/zoowayss/ghostty-fish-theme/main/install.sh | bash -s -- --set-default-shell
```

或者 clone 后本地运行：

```bash
git clone https://github.com/zoowayss/ghostty-fish-theme.git
cd ghostty-fish-theme
bash install.sh            # 可加 --set-default-shell
```

## 脚本做了什么

1. `brew install fish starship`，`brew install --cask ghostty`（已装的跳过）
2. 下载 MesloLGS NF 四个字重到 `~/Library/Fonts`
3. 写入下列文件，已有且内容不同的会先备份为 `*.bak.<时间戳>`：
   - `~/.config/ghostty/config`
   - `~/.config/starship.toml`
   - `~/.config/fish/config.fish`
   - `~/.config/fish/functions/fish_user_key_bindings.fish`

## 文件结构

```
ghostty/config
starship.toml
fish/config.fish
fish/functions/fish_user_key_bindings.fish
install.sh
```
