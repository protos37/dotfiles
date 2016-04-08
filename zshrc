source $HOME/.antigen/antigen.zsh

export LC_ALL=en_US.utf-8
export LANG=en_US.utf-8

LIME_SHOW_HOSTNAME=1
LIME_DIR_DISPLAY_COMPONENTS=3

antigen use oh-my-zsh

antigen bundle yous/lime
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle autojump

antigen apply

function add_to_path_once() {
  path=("$1" $path)
}

# Add /usr/local/bin to PATH for Mac OS X
if [[ "$(uname)" == 'Darwin' ]]; then
  add_to_path_once "/usr/local/bin:/usr/local/sbin"
fi

# Set PATH to include user's bin if it exists
if [[ -d "$HOME/bin" ]]; then
  add_to_path_once "$HOME/bin"
fi

# Load Linuxbrew
if [[ -d "$HOME/.linuxbrew" ]]; then
  add_to_path_once "$HOME/.linuxbrew/bin"
  export MANPATH="$HOME/.linuxbrew/share/man:$MANPATH"
  export INFOPATH="$HOME/.linuxbrew/share/info:$INFOPATH"
fi

# Load pyenv
if which pyenv &> /dev/null; then
  eval "$(pyenv init -)"
elif [ -e "$HOME/.pyenv" ]; then
  add_to_path_once "$HOME/.pyenv/bin"
  eval "$(pyenv init -)"
fi

# Load RVM
if [[ -d "$HOME/.rvm" ]]; then
  add_to_path_once "$HOME/.rvm/bin"
fi

# Unset local functions
unset -f add_to_path_once

alias tmux='tmux -2'

if [ -f "$HOME/.zshrc.local" ]; then
  source $HOME/.zshrc.local
fi
