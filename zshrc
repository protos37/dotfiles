source $HOME/.antigen/antigen.zsh

export LC_ALL=en_US.utf-8
export LANG=en_US.utf-8

LIME_SHOW_HOSTNAME=1
LIME_DIR_DISPLAY_COMPONENTS=3

function add_to_path_once() {
  path=("$1" $path)
}

# Add /usr/local/bin to PATH for Mac OS X
if [[ "$(uname)" == 'Darwin' ]]; then
  add_to_path_once "/usr/local/bin:/usr/local/sbin"
fi

# Load Linuxbrew
if [[ -d "$HOME/.linuxbrew" ]]; then
  add_to_path_once "$HOME/.linuxbrew/bin"
  export MANPATH="$HOME/.linuxbrew/share/man:$MANPATH"
  export INFOPATH="$HOME/.linuxbrew/share/info:$INFOPATH"
fi

# Set PATH to include user's bin if it exists
if [[ -d "$HOME/bin" ]]; then
  add_to_path_once "$HOME/bin"
fi

antigen use oh-my-zsh

antigen bundle yous/lime
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle autojump
antigen bundle pyenv

antigen apply

# Unset local functions
unset -f add_to_path_once

alias tmux='tmux -2'

if [[ -f "$HOME/.zshrc.local" ]]; then
  source $HOME/.zshrc.local
fi
