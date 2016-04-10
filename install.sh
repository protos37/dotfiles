#!/bin/bash
DIRNAME="$(dirname "$0")"
DIR="$(cd "$DIRNAME" && pwd)"

function echoerr()
{
  echo "$@" 1>&2
}

function git_clone()
{
  if [ ! -e "$HOME/$2" ]; then
    echo "Cloning '$1'..."
    git clone "$1" "$HOME/$2"
  else
    echoerr "~/$2 already exists."
  fi
}

function replace_file()
{
  DEST=${2:-.$1}

  # http://www.tldp.org/LDP/Bash-Beginners-Guide/html/sect_07_01.html
  # File exists and is a directory.
  [ ! -d "$(dirname "$HOME/$DEST")" ] && mkdir -p "$(dirname "$HOME/$DEST")"

  # FILE exists and is a symbolic link.
  if [ -h "$HOME/$DEST" ]; then
    if rm "$HOME/$DEST" && ln -s "$DIR/$1" "$HOME/$DEST"; then
      echo "Updated ~/$DEST"
    else
      echoerr "Failed to update ~/$DEST"
    fi
  # FILE exists.
  elif [ -e "$HOME/$DEST" ]; then
    if mv --backup=number "$HOME/$DEST" "$HOME/$DEST.old"; then
      echo "Renamed ~/$DEST to ~/$DEST.old"
      if ln -s "$DIR/$1" "$HOME/$DEST"; then
        echo "Created ~/$DEST"
      else
        echoerr "Failed to create ~/$DEST"
      fi
    else
      echoerr "Failed to rename ~/$DEST to ~/$DEST.old"
    fi
  else
    if ln -s "$DIR/$1" "$HOME/$DEST"; then
      echo "Created ~/$DEST"
    else
      echoerr "Failed to create ~/$DEST"
    fi
  fi
}

function replace_dotfiles()
{
  replace_file tmux.conf
  replace_file gitconfig
  replace_file gitignore_global
}

case "$1" in
  link)
    replace_dotfiles
    ;;
  bash)
    replace_file bashrc
    replace_dotfiles
    echo 'Done.'
    ;;
  zsh)
    git_clone git://github.com/tarjoilija/zgen.git .zgen
    replace_file zshrc
    replace_dotfiles
    zsh -i -c "zgen reset; zgen update"
    echo 'You can chagne your default shell with:'
    echo ''
    echo '    chsh -s `which zsh`'
    echo ''
    echo 'Done.'
    ;;
  vim)
    git_clone git://github.com/VundleVim/Vundle.vim.git .vim/bundle/Vundle.vim
    replace_file vimrc
    vim +PluginInstall +qall
    echo 'Done.'
    ;;
  git)
    read -p "Enter your name to be configured with git: " un
    read -p "Enter your email to be configured with git: " um
    git config --global --replace-all user.name "$un"
    git config --global --replace-all user.email "$um"
    ;;
  *)
    echo "usage: $(basename "$0") <command>"
    echo ''
    echo 'Available commands:'
    echo '    link    Install miscellaneous'
    echo '    bash    Install general bashrc'
    echo '    zsh     Install antigen and zshrc'
    echo '    vim     Install Vundle and vimrc'
    echo '    git     Globally config git with name and email'
esac
