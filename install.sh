#!/bin/bash

cd $(dirname $0)/dotfiles
for FILENAME in *
do
	if [ -e ~/.$FILENAME ]
	then
		mv ~/.$FILENAME ~/.$FILENAME.old
	fi
	ln -s $(pwd)/$FILENAME ~/.$FILENAME
done
cd - > /dev/null

# Download Vundle
git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim

# Install Vundle
vim +PluginInstall +qall
