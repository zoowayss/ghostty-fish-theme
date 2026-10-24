# fish 配置（配合 Ghostty + Starship 使用）

# Homebrew 路径：确保 fish 能找到 starship、brew 等命令。
fish_add_path /opt/homebrew/bin /opt/homebrew/sbin $HOME/.local/bin

if status is-interactive
    # 关闭 fish 默认欢迎语
    set -g fish_greeting

    # Ctrl+L：清当前屏幕，并清空终端 scrollback
    function clear_all
        printf '\033[H\033[2J\033[3J'
        commandline -f repaint
    end

    bind \cl clear_all

    # 启用 Starship 提示符，主题来自 ~/.config/starship.toml
    starship init fish | source
end
