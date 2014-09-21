xsetroot -cursor_name left_ptr
setxkbmap -layout gb -option caps:super
/usr/lib/systemd/systemd --user &

find ~/Pictures/Wallpaper -type f \( -name '*.jpg' -o -name '*.png' \) -print0 |
    shuf -n1 -z | xargs -0 feh --bg-scale

for f in /etc/X11/xinit/xinitrc.d/*; do source $f; done

KEY=f468be2468
SSID=BTHub5-X6GM
IFACE=wlan0
CONF=/tmp/wifi.conf

sudo wpa_passphrase $SSID $KEY >$CONF
sudo wpa_supplicant -B -i $IFACE -c $CONF
sudo dhcpcd -A $IFACE

start-pulseaudio-x11

exec xmonad
