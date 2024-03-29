#!/bin/bash
sudo sed -i 's/ports.ubuntu.com/mirrors.tuna.tsinghua.edu.cn/g' /etc/apt/sources.list
if [ $? -ne 0 ]; then
    echo "Failed to change apt source."
    exit $?
fi
sudo apt update
if [ $? -ne 0 ]; then
    echo "Failed to update apt source list."
    exit $?
fi
sudo apt upgrade -y
if [ $? -ne 0 ]; then
    echo "Failed to upgrade packages."
    exit $?
fi
sudo apt install -y git zsh curl wget vim cmake gcc
if [ $? -ne 0 ]; then
    echo "Failed to install software."
    exit $?
fi
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
if [ $? -ne 0 ]; then
    echo "Failed to download oh-my-zsh install script."
    exit $?
fi
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
if [ $? -ne 0 ]; then
    echo "Failed to clone zsh-syntax-highlighting."
    exit $?
fi
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
if [ $? -ne 0 ]; then
    echo "Failed to clone zsh-autosuggestions."
    exit $?
fi
sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="ys"/g' ~/.zshrc
if [ $? -ne 0 ]; then
    echo "Failed to setup zsh theme."
    exit $?
fi
sed -i 's/plugins=(git)/plugins=(git zsh-syntax-highlighting zsh-autosuggestions)/g' ~/.zshrc
if [ $? -ne 0 ]; then
    echo "Failed to setup zsh plugins."
    exit $?
fi
source ~/.zshrc