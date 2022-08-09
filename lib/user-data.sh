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
sudo cp -r /home/ubuntu/.ssh/* /home/jflabonte/.ssh/*
sudo chown -R jflabonte: /home/jflabonte/.ssh

sudo su - jflabonte
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

git clone https://github.com/AstroNvim/AstroNvim ~/.config/nvim
nvim +PackerSync

reboot
