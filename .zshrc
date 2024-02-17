# This file is sourced only for interactive shells. It
# should contain commands to set up aliases, functions,
# options, key bindings, etc.
#
# Global Order: zshenv, zprofile, zshrc, zlogin
#
# Resources:
# - https://wiki.archlinux.org/title/zsh

##############
## Theme
##############
fpath=($HOME/.zsh/themes $fpath)
autoload -U promptinit && promptinit
autoload colors && colors  # Load colors (if you want to use colors in prompt)
prompt tspng

##############
## Completion
##############
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' rehash true
zstyle ':completion:*' special-dirs true

setopt correctall  # enable auto-correction of commands typed
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
setopt share_history          # share command history data

##############
## Key Bindings
##############
bindkey "^A"      beginning-of-line                   # ctrl-a  
bindkey "^E"      end-of-line                         # ctrl-e
bindkey "[B"      history-search-forward              # down arrow
bindkey "[A"      history-search-backward             # up arrow
bindkey "^D"      delete-char                         # ctrl-d

##############
## 3rd Party Apps
##############

# Fzf Ctrl-R replacement
if (( $+commands[fzf] )); then
    source "${HOMEBREW_PREFIX}/opt/fzf/shell/completion.zsh"
    source "${HOMEBREW_PREFIX}/opt/fzf/shell/key-bindings.zsh"
fi

# pyenv
if (( $+commands[pyenv] )); then
    export PYENV_ROOT="$HOME/.pyenv"
    eval "$(pyenv init -)"
fi

# Google Cloud SDK
if (( $+commands[gcloud] )); then
    source ${HOMEBREW_PREFIX}/share/google-cloud-sdk/completion.zsh.inc
fi

# Direnv, load and unload environment variables based on current directory
if (( $+commands[direnv] )); then
    eval "$(direnv hook zsh)"
fi

if [[ -r $HOME/.zshrc.local ]]; then
    source $HOME/.zshrc.local
fi
