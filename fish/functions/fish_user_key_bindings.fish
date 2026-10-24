function __theme_echo_ctrl_c --description 'Show ^C when cancelling the current fish command line'
    commandline -f end-of-line
    printf ' ^C\n'
    commandline ''
    commandline -f repaint
end

function fish_user_key_bindings
    bind ctrl-c __theme_echo_ctrl_c
end
