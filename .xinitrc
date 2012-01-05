xsetroot -cursor_name left_ptr
setxkbmap -layout gb

trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand true --width 5 --transparent true --tint 0x191970 --height 12 &

pidgin &

$HOME/Voc/bin/rotatewallpaper.sh &

emacs --daemon &

exec ck-launch-session xmonad