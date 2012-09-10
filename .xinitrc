xsetroot -cursor_name left_ptr
setxkbmap -layout gb

if [ -f $HOME/.Xmodmap ]; then
    xmodmap $HOME/.Xmodmap
fi

xautolock -time 10 -locker "sudo systemctrl start suspend.target" &

emacsclient -c &

exec qtile
