# This file is sourced for every shell instance.
#
# Configures key environment variables without
# output commands or tty assumptions.
# NOTE: do not configure PATH here, use ~/.zprofile or ~/.zshrc instead.
#
# zsh initialization order: /etc/zshenv -> ~/.zshenv ->
#                           /etc/zprofile -> ~/.zprofile ->
#                           /etc/zshrc -> ~/.zshrc ->
#                           /etc/zlogin -> ~/.zlogin
#
# Resources:
# - https://zsh.sourceforge.io/Doc/Release/Files.html
# - https://github.com/novas0x2a/config-files/blob/master/.zshenv
# - https://gist.github.com/Linerre/f11ad4a6a934dcf01ee8415c9457e7b2

export HOMEBREW_NO_ANALYTICS=1

# Language settings
export LANG='en_US.UTF-8'
export LC_CTYPE='en_US.UTF-8'

# grep / ripgrep
if (( $+commands[rg] )); then
    export GREP='rg'
    export RIPGREP_CONFIG_PATH="$HOME/.config/rg/config"
else
    # Enable color in grep
    export GREP='grep'
    export GREP_OPTIONS='--color=auto'
    export GREP_COLOR='3;33'
fi

# Python
export PIP_REQUIRE_VIRTUALENV=true

# Pager
if (( $+commands[bat] )); then
    export PAGER='bat'
else
    export PAGER='less'
    export LESSCHARSET='utf-8'
fi

case $(uname -s) in
    Darwin) export BROWSER='open';;
    *) export BROWSER='firefox';;
esac

export EDITOR='vim'
export VISUAL='vim'

export CLICOLOR=1
export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=36;01:cd=33;01:su=31;40;07:sg=36;40;07:tw=32;40;07:ow=33;40;07:'

if [[ -r $HOME/.zshenv.local ]]; then
    source $HOME/.zshenv.local
fi
