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
