#!/bin/bash
echo "Installing jetson-stats..."
sudo pip3 install -U jetson-stats
if [ $? -ne 0 ]; then
    echo "Failed to install jetson-stats."
    exit $?
fi
echo "Overwriting /etc/apt/preferences.d/00-switch-bsp-restrictions"
sudo cat << EOF > /etc/apt/preferences.d/00-switch-bsp-restrictions
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
if [ $? -eq 0 ]; then
    echo "Failed to overwrite /etc/apt/sources.list.d/nvidia-l4t-apt-source.list"
    exit $?
fi
echo "Overwrite /etc/apt/sources.list.d/nvidia-l4t-apt-source.list"
cat << EOF > /etc/apt/sources.list.d/nvidia-l4t-apt-source.list
deb https://repo.download.nvidia.com/jetson/common r32.7 main
deb https://repo.download.nvidia.com/jetson/t210 r32.7 main
EOF
if [ $? -eq 0 ]; then
    echo "Failed to overwrite /etc/apt/sources.list.d/nvidia-l4t-apt-source.list"
    exit $?
fi
echo "touch /etc/nv_boot_control.conf"
sudo touch /etc/nv_boot_control.conf
if [ $? -eq 0 ]; then
    echo "Failed to touch /etc/nv_boot_control.conf"
    exit $?
fi
echo "mkdir /opt/nvidia/l4t-packages"
sudo mkdir /opt/nvidia/l4t-packages
if [ $? -eq 0 ]; then
    echo "Failed to mkdir /opt/nvidia/l4t-packages"
    exit $?
fi
echo "touch /opt/nvidia/l4t-packages/.nv-l4t-disable-boot-fw-update-in-preinstall"
sudo touch /opt/nvidia/l4t-packages/.nv-l4t-disable-boot-fw-update-in-preinstall
if [ $? -eq 0 ]; then
    echo "Failed to touch /opt/nvidia/l4t-packages/.nv-l4t-disable-boot-fw-update-in-preinstall"
    exit $?
fi
echo "Update and Upgrade..."
sudo apt update
if [ $? -eq 0 ]; then
    echo "Failed to apt update"
    exit $?
fi
sudo apt dist-upgrade
if [ $? -eq 0 ]; then
    echo "Failed to apt dist-upgrade"
    exit $?
fi
