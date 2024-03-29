#!/bin/bash
sudo pip3 install -U jetson-stats
if [ $? -ne 0 ]; then
    echo "Failed to install jetson-stats."
    exit $?
fi
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
sudo apt install -y git zsh curl wget vim cmake gcc python3-pip
if [ $? -ne 0 ]; then
    echo "Failed to install software."
    exit $?
fi
pip3 config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
if [ $? -ne 0 ]; then
    echo "Failed to setup current user pip3 config."
    exit $?
fi
sudo pip3 config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
if [ $? -ne 0 ]; then
    echo "Failed to setup root user pip3 config."
    exit $?
fi
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
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