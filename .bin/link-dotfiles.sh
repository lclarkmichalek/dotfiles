#!/bin/sh

DOTFILES_DIR=`dirname $(readlink -f $0)`
cd $DOTFILES_DIR

git ls-files | xargs ln -sft $HOME
