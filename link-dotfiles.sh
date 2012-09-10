#!/bin/sh
ERROR_FILE=/tmp/link-errors

DOTFILES_DIR=`dirname $(readlink -f $0)`
cd $DOTFILES_DIR

rm $ERROR_FILE
success=0
for file in `git ls-files`; do
    echo -n "Linking $file..."
    file=`readlink -f $file`
    ln -sft $HOME $file 2&>$ERROR_FILE
    if [ $? == 0 ]; then
        echo "Done"
    else
        echo "Failed"
        success=1;
    fi
done

if [ $success == 0 ]; then
    echo "Linked all dotfiles"
else
    echo "Some linking failed, errors logged in $ERROR_FILE"
fi

rm $HOME/link-dotfiles.sh
