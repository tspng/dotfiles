# This file is sourced for every shell instance. 
#
# Configures search paths and key environment variables
# without output commands or tty assumptions. 
# 
# zsh initialization order: zshenv -> zprofile -> zshrc -> zlogin.
#
# Resources:
# - https://github.com/novas0x2a/config-files/blob/master/.zshenv
# - https://gist.github.com/Linerre/f11ad4a6a934dcf01ee8415c9457e7b2

typeset -U path PATH
path=(~/bin ~/.local/bin ~/.cargo/bin $path)

# Homebrew for Apple Silicon
if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi
# Homebrew for Apple x86_64
if [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
fi
export HOMEBREW_NO_ANALYTICS=1

# Language settings
export LANG='en_US.UTF-8'
export LC_CTYPE='en_US.UTF-8'

# grep / ripgrep
if (( $+commands[rg] )); then
    export GREP='rg'
else
    # Enable color in grep
    export GREP='grep'
    export GREP_OPTIONS='--color=auto'
    export GREP_COLOR='3;33'
fi

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
