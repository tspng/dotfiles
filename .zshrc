# This file is sourced only for interactive shells. It
# should contain commands to set up aliases, functions,
# options, key bindings, etc.
#
# Global Order: zshenv, zprofile, zshrc, zlogin
#
# Resources:
# - https://wiki.archlinux.org/title/zsh
# - https://0xmachos.com/2021-05-13-zsh-path-macos/
# - https://gist.github.com/Linerre/f11ad4a6a934dcf01ee8415c9457e7b2

##############
## Path
##############
# Due to `path_helper` being called in `/etc/zshenv`,
# PATH needs to be set up here.
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

##############
## Theme
##############
fpath=($HOME/.zsh/themes $fpath)
autoload -Uz promptinit && promptinit
autoload colors && colors  # Load colors (if you want to use colors in prompt)
prompt tspng

##############
## Completion
##############
fpath=($HOMEBREW_PREFIX/share/zsh/site-functions $fpath)
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' rehash true
zstyle ':completion:*' special-dirs true

# setopt extendedglob  # enable extended globbing

##############
## Aliases
##############
alias psgrep="ps wwaux | $GREP"
alias hgrep="history 1 | $GREP"
alias bs="brew services"
alias rm_pyc="find . -name \*\.pyc -delete"
# My dotfiles git alias for using the bare repository
alias dotfiles="git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME"

##############
## History
##############
HISTFILE="${HOME}/.zhistory"
HISTSIZE=50000                 # The maximum number of events to save in the internal history.
SAVEHIST=10000                 # The maximum number of events to save in the history file.

## History command configuration
setopt extended_history       # record timestamp of command in HISTFILE
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
setopt inc_append_history     # add commands to HISTFILE in order of execution

##############
## Key Bindings
##############
bindkey "^a"      beginning-of-line           # ctrl-a
bindkey "^e"      end-of-line                 # ctrl-e
#bindkey "[b"      history-search-forward      # down arrow
#bindkey "[a"      history-search-backward     # up arrow
bindkey "^d"      delete-char                 # ctrl-d
# iterm2
bindkey '^[b'     backward-word               # alt/option-left arrow
bindkey '^[f'     forward-word                # alt/option-right arrow
# alacritty
bindkey '^[[1;3D' backward-word               # alt/option-left arrow
bindkey '^[[1;3C' forward-word                # alt/option-right arrow
#bindkey -e        # Default to standard emacs bindings

##############
## Misc Env
##############

export LANG='en_US.UTF-8'
export LC_CTYPE='en_US.UTF-8'

export CLICOLOR=1
export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=36;01:cd=33;01:su=31;40;07:sg=36;40;07:tw=32;40;07:ow=33;40;07:'

export EDITOR='vim'
export VISUAL='vim'

case $(uname -s) in
    Darwin) export BROWSER='open';;
    *) export BROWSER='firefox';;
esac

export HOMEBREW_NO_ANALYTICS=1

##############
## 3rd-party Apps
##############

# Fzf Ctrl-R replacement
if (( $+commands[fzf] )); then
    eval "$(fzf --zsh)"
fi

# Rye
if [[ -d "$HOME/.rye/shims" ]]; then
    export PATH="$HOME/.rye/shims:$PATH"
 
# Python & pyenv
elif (( $+commands[pyenv] )); then
    export PYENV_ROOT="$HOME/.pyenv"
    eval "$(pyenv init -)"
fi
export PIP_REQUIRE_VIRTUALENV=true

# Google Cloud SDK
if (( $+commands[gcloud] )); then
    source ${HOMEBREW_PREFIX}/share/google-cloud-sdk/completion.zsh.inc
fi

# Direnv, load and unload environment variables based on current directory
if (( $+commands[direnv] )); then
    eval "$(direnv hook zsh)"
fi

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

# Pager (less / bat)
if (( $+commands[bat] )); then
    export PAGER='bat'
else
    export PAGER='less'
    export LESSCHARSET='utf-8'
fi

# Orbstack
source ~/.orbstack/shell/init.zsh 2> /dev/null || :

if [[ -r $HOME/.zshrc.local ]]; then
    source $HOME/.zshrc.local
fi
