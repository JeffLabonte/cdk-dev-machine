#!/bin/bash

sudo su

add-apt-repository -y ppa:neovim-ppa/stable

apt update
apt -y dist-upgrade
apt install -y neofetch zsh neovim tmux mosh openssh-server mosh git

echo "the_dev_machine" > /etc/hostname


curl -fsSL https://tailscale.com/install.sh | sh

systemctl enable --now sshd

useradd -m -G sudo -s /bin/zsh jflabonte


echo 'sudo cp -r /home/ubuntu/.ssh/* /home/jflabonte/.ssh/*' > /home/jflabonte/boostrap.sh
echo 'sudo chown -R jflabonte: /home/jflabonte/.ssh' >> /home/jflabonte/boostrap.sh
echo 'sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"' >> /home/jflabonte/boostrap.sh
echo 'git clone https://github.com/AstroNvim/AstroNvim ~/.config/nvim"' >> /home/jflabonte/boostrap.sh
echo 'nvim +PackerSync' >> /home/jflabonte/boostrap.sh

reboot
