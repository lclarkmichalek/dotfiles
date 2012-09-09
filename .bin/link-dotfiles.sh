#!/bin/sh

DOTFILES_DIR=`dirname $(dirname $(readlink -f $0))`
cd $DOTFILES_DIR

for file in `git ls-files`; do
    file=`readlink -f $file`
    ln -sft $HOME $file
done
