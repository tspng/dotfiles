# Only set environment variables here that are not or do not depend on PATH.
# macOS will run `path_helper` in `/etc/zprofile` to setup and re-organize PATH. 
# We need to set up PATH after in .zshrc.
#
# Global Order: zshenv, zprofile, zshrc, zlogin

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


##############
## 3rd-party
##############

export HOMEBREW_NO_ANALYTICS=1

# Variants for 3rd-party apps
export PREFER_PYTHON_TOOL="pyenv" 
# export PREFER_PYTHON_TOOL="rye" 


export PIP_REQUIRE_VIRTUALENV=true
export PYENV_VIRTUALENV_DISABLE_PROMPT=1

if [[ -r $HOME/.zshenv.local ]]; then
    source $HOME/.zshenv.local
fi
