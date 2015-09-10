#!/bin/bash

replace () {
	if [ -e $1 ] || [ -h $1 ]; then
		mv $1 $1.old
	fi
}

install () {
	replace ~/.$1
	ln -s $(pwd)/$1 ~/.$1
}

if [[ $# -eq 0 ]]; then
	echo "usage: $(basename $0) <command>"
fi

pushd $(dirname $0)/dotfiles > /dev/null
for arg in $@
do
	case $arg in
		git)
			install gitconfig
			install gitignore_global
			;;
		vim)
			if [ ! -e ~/.vim/bundle/Vundle.vim ]; then
				replace ~/.vim/bundle/Vundle.vim
				git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
			fi
			install vimrc
			vim +PluginInstall +PluginUpdate +qall
			;;
		ycm)
			pushd ~/.vim/bundle/YouCompleteMe
			./install.py --clang-completer
			popd
			;;
		zsh)
			if [ ! -e ~/.oh-my-zsh ]; then
				replace ~/.oh-my-zsh
				sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
			fi
			install zshrc
			install tmux.conf
			;;
		*)
			echo "unknown command: $arg"
			;;
	esac
done
popd > /dev/null
