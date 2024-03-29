#!/bin/bash
echo "Installing jetson-stats..."
sudo pip3 install -U jetson-stats
if [ $? -ne 0 ]; then
    echo "Failed to install jetson-stats."
    exit $?
fi
echo "Overwriting /etc/apt/preferences.d/00-switch-bsp-restrictions"
sudo tee /etc/apt/preferences.d/00-switch-bsp-restrictions > /dev/null << 'EOF'
# Disallow L4T 32.4.x
Package: nvidia-l4t-*
Pin: version 32.4.*
Pin-Priority: -1

# Disallow L4T 32.5.x
Package: nvidia-l4t-*
Pin: version 32.5.*
Pin-Priority: -1

# Disallow L4T 32.6.x
Package: nvidia-l4t-*
Pin: version 32.6.*
Pin-Priority: -1

# Disallow L4T 32.7.x
# Package: nvidia-l4t-*
# Pin: version 32.7.*
# Pin-Priority: -1
EOF
if [ $? -ne 0 ]; then
    echo "Failed to overwrite /etc/apt/sources.list.d/nvidia-l4t-apt-source.list"
    exit $?
fi
echo "Overwrite /etc/apt/sources.list.d/nvidia-l4t-apt-source.list"
sudo tee /etc/apt/sources.list.d/nvidia-l4t-apt-source.list > /dev/null << 'EOF'
deb https://repo.download.nvidia.com/jetson/common r32.7 main
deb https://repo.download.nvidia.com/jetson/t210 r32.7 main
EOF
if [ $? -ne 0 ]; then
    echo "Failed to overwrite /etc/apt/sources.list.d/nvidia-l4t-apt-source.list"
    exit $?
fi
if [ ! -f /etc/nv_boot_control.conf ]; then
    echo "touch /etc/nv_boot_control.conf"
    sudo touch /etc/nv_boot_control.conf
    if [ $? -ne 0 ]; then
        echo "Failed to touch /etc/nv_boot_control.conf"
        exit $?
    fi
fi
if [ ! -d /opt/nvidia/l4t-packages ]; then
    echo "mkdir /opt/nvidia/l4t-packages"
    sudo mkdir /opt/nvidia/l4t-packages
    if [ $? -ne 0 ]; then
        echo "Failed to mkdir /opt/nvidia/l4t-packages"
        exit $?
    fi
fi
if [ ! -f /opt/nvidia/l4t-packages/.nv-l4t-disable-boot-fw-update-in-preinstall ]; then
    echo "touch /opt/nvidia/l4t-packages/.nv-l4t-disable-boot-fw-update-in-preinstall"
    sudo touch /opt/nvidia/l4t-packages/.nv-l4t-disable-boot-fw-update-in-preinstall
    if [ $? -ne 0 ]; then
        echo "Failed to touch /opt/nvidia/l4t-packages/.nv-l4t-disable-boot-fw-update-in-preinstall"
        exit $?
    fi
fi
echo "Update and Upgrade..."
sudo apt update
if [ $? -ne 0 ]; then
    echo "Failed to apt update"
    exit $?
fi
sudo apt dist-upgrade
if [ $? -ne 0 ]; then
    echo "Failed to apt dist-upgrade"
    exit $?
fi
