#!/bin/bash

if [ -z $1 ]; then
    echo "Need server address"
    echo "bootstrap.sh <address> <rootpassword> <username>"
    exit
fi

if [ -z $2 ]; then
    echo "Need root password"
    echo "bootstrap.sh <address> <rootpassword> <username>"
    exit
fi

if [ -z $3 ]; then
    echo "Need new user username"
    echo "bootstrap.sh <address> <rootpassword> <username>"
    exit
fi

cd `dirname $0`

echo "Pinging machine"
echo "==============="
# Make sure that the machine is up
ping $1 -c 1 -W 1 >/dev/null || exit

echo "Uploading public keys"
echo "====================="
scp $HOME/.ssh/id_*.pub root@$1:.ssh/authorized_keys2

echo "Runing update & user creation"
echo "============================="
ssh root@$1 "bash -s" <<EOF
cd \$HOME
if [ -z "\$(which git >>/dev/null)" ]; then
    if (which apt-get >/dev/null); then
        apt-get --assume-yes update
        apt-get --assume-yes upgrade
        apt-get --assume-yes install git-core
    else if (which pacman >/dev/null); then
        pacman --noconfirm -Syu
        pacman --noconfirm -Syu
        pacman -S --noconfirm git
    fi
    fi
fi

useradd $3 -G wheel -ms \$(which zsh || which bash)
echo $2 | passwd $3
mkdir -p /home/$3/.ssh
cp /root/.ssh/authorized_keys2 /home/$3/.ssh/authorized_keys
chown $3:$3 /home/$3/.ssh/authorized_keys
EOF

echo "Cloning dotfiles repo & setting up sshd"
echo "======================================="
ssh $3@$1 "bash -s" <<EOF
GIT_REMOTE=$(git remote show origin -n | grep -oh "git@\S*" | head -1)
git clone \$GIT_REMOTE .dotfiles

.dotfiles/.bin/link-dotfiles.sh

echo $2 | su -c <<EOS
cp /etc/ssh/sshd_config /tmp/sshd_config
sed -i "s/PasswordAuthentication/#PasswordAuthentication/g" /tmp/sshd_config
echo "PasswordAuthentication no" >>/tmp/sshd_config
sed -i "s/PermitRootLogin/#PermitRootLogin/g" /tmp/sshd_config
echo "PermitRootLogin no" >>/tmp/sshd_config
cp /tmp/sshd_config /etc/ssh/sshd_config
EOS
EOF

echo "Finished"
echo "========"
