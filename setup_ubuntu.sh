#!/bin/bash
echo "Change apt source to mirrors.tuna.tsinghua.edu.cn."
sudo sed -i 's/ports.ubuntu.com/mirrors.tuna.tsinghua.edu.cn/g' /etc/apt/sources.list
if [ $? -ne 0 ]; then
    echo "Failed to change apt source."
    exit $?
fi
echo "Update apt source list."
sudo apt update
if [ $? -ne 0 ]; then
    echo "Failed to update apt source list."
    exit $?
fi
echo "Upgrade packages."
sudo apt upgrade -y
if [ $? -ne 0 ]; then
    echo "Failed to upgrade packages."
    exit $?
fi
echo "Install software."
sudo apt install -y git zsh curl wget vim cmake gcc python3-pip
if [ $? -ne 0 ]; then
    echo "Failed to install software."
    exit $?
fi
echo "Setup current user git config."
mkdir -p ~/.pip && cat << EOF > ~/.pip/pip.conf
[global]
index-url = https://pypi.tuna.tsinghua.edu.cn/simple
[install]
trusted-host = https://pypi.tuna.tsinghua.edu.cn
EOF
if [ $? -ne 0 ]; then
    echo "Failed to setup current user pip3 config."
    exit $?
fi
echo "Setup root user git config."
sudo mkdir -p ~/.pip && sudo cat << EOF > ~/.pip/pip.conf
[global]
index-url = https://pypi.tuna.tsinghua.edu.cn/simple
[install]
trusted-host = https://pypi.tuna.tsinghua.edu.cn
EOF
if [ $? -ne 0 ]; then
    echo "Failed to setup root user pip3 config."
    exit $?
fi
echo "Download oh-my-zsh install script."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
if [ $? -ne 0 ]; then
    echo "Failed to download oh-my-zsh install script."
    exit $?
fi
echo "Clone zsh-syntax-highlighting."
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
if [ $? -ne 0 ]; then
    echo "Failed to clone zsh-syntax-highlighting."
    exit $?
fi
echo "Clone zsh-autosuggestions."
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
if [ $? -ne 0 ]; then
    echo "Failed to clone zsh-autosuggestions."
    exit $?
fi
echo "Setup zsh theme."
sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="ys"/g' ~/.zshrc
if [ $? -ne 0 ]; then
    echo "Failed to setup zsh theme."
    exit $?
fi
echo "Setup zsh plugins."
sed -i 's/plugins=(git)/plugins=(git zsh-syntax-highlighting zsh-autosuggestions)/g' ~/.zshrc
if [ $? -ne 0 ]; then
    echo "Failed to setup zsh plugins."
    exit $?
fi
source ~/.zshrc