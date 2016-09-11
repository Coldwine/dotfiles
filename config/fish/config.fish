source /usr/local/share/autojump/autojump.fish

set -gx EDITOR nvim
set -gx FZF_CTRL_T_COMMAND $FZF_DEFAULT_COMMAND
set -gx FZF_DEFAULT_COMMAND 'ag -g ""'
set -gx FZF_TMUX 1
set -gx LANG en_GB.UTF-8
set -gx NVIM_TUI_ENABLE_CURSOR_SHAPE 1
set -gx OPENSSL_INCLUDE_DIR /usr/local/opt/openssl/include
set -gx OPENSSL_ROOT_DIR /usr/local/opt/openssl
