#!/bin/bash

sudo su

add-apt-repository -y ppa:neovim-ppa/stable

apt update
apt -y dist-upgrade
apt install -y neofetch zsh neovim tmux mosh openssh-server mosh 


sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
curl -fsSL https://tailscale.com/install.sh | sh

systemctl enable --now sshd

useradd -m -G sudo -s /bin/zsh jflabonte
cp -r /home/ubuntu/.ssh /home/jflabonte/.ssh

reboot
