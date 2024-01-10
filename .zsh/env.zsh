# PATH stuff
typeset -U path

# Homebrew for Apple Silicon
if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
    prepend_path /opt/homebrew/bin
    prepend_path /opt/homebrew/sbin
fi
# Homebrew for Apple x86_64
if [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
    prepend_path /usr/local/bin
    prepend_path /usr/local/sbin
fi

# Local binaries
prepend_path ~/bin

# Language settings
export LANG='en_US.UTF-8'
export LC_CTYPE='en_US.UTF-8'
# CTAGS sorting in VIM/Emacs is better behaved with this in place
export LC_COLLATE=C

# grep / ripgrep
if (( $+commands[rg] )); then
    export GREP='rg'
else
    # Enable color in grep
    export GREP='grep'
    export GREP_OPTIONS='--color=auto'
    export GREP_COLOR='3;33'
fi

if [[ "$OSTYPE" == darwin* ]]; then
    export BROWSER='open'
fi

export EDITOR='vim'
export PAGER='less'
export LESSCHARSET='utf-8'

# Google Cloud SDK
export CLOUDSDK_ACTIVE_CONFIG_NAME=default

# Java
JAVA_HOME=$(/usr/libexec/java_home 2> /dev/null)
if [[ $? -eq 0 ]]; then
    export JAVA_HOME
fi

# pipx
if (( $+commands[pipx] )); then
    prepend_path $HOME/.local/bin
fi

# pyenv
if (( $+commands[pyenv] )); then
    export PYENV_ROOT="$HOME/.pyenv"
    eval "$(pyenv init -)"
fi

# TCL/Tk
TK_BIN_PATH=${HOMEBREW_PREFIX}/opt/tcl-tk/bin
if [[ -x $TK_BIN_PATH ]]; then
    append_path $TK_BIN_PATH
fi

# TEX Live
TEXLIVE_DIR=${HOMEBREW_PREFIX}/texlive/2023
if [[ -d $TEXLIVE_DIR ]]; then
    append_path ${TEXLIVE_DIR}/bin/universal-darwin
fi

# McFly Ctrl-R replacement
if (( $+commands[mcfly] )); then
    export MCFLY_KEY_SCHEME=vim
    export MCFLY_FUZZY=2
    eval "$(mcfly init zsh)"
fi

# Fzf Ctrl-R replacement
if (( $+commands[fzf] )); then
    FZF_PATH=$(brew --prefix)/opt/fzf/bin
    if ! path_is_in_path "$FZF_PATH"; then
        append_path $FZF_PATH
    fi
fi

# Google Cloud SDK
GOOGLE_CLOUD_SDK_PATH="$(brew --prefix)/share/google-cloud-sdk"
if [[ -d $GOOGLE_CLOUD_SDK_PATH ]]; then
    echo "Google Cloud SDK found at $GOOGLE_CLOUD_SDK_PATH"
    source "${GOOGLE_CLOUD_SDK_PATH}/path.zsh.inc"
    source "${GOOGLE_CLOUD_SDK_PATH}/completion.zsh.inc"
fi

# Direnv, load and unload environment variables based on current directory
if (( $+commands[direnv] )); then
    eval "$(direnv hook zsh)"
fi
