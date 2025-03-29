#!/bin/bash

set -ouex pipefail

# Update release file
sed -i -e 's/ID=silverblue/ID=experimental/g' /usr/lib/os-release
sed -i -e 's/Silverblue/Bluefora/g' /usr/lib/os-release
sed -i -e 's/Fedora Linux 41 (Workstation Edition)/Bluefora Linux 41 (Experimental Edition)/g' /usr/lib/os-release
sed -i -e 's/DEFAULT_HOSTNAME="fedora"/DEFAULT_HOSTNAME="bluefora"/g' /usr/lib/os-release

rpm-ostree ex rebuild

# Cleanup
dnf5 -y remove \
    firefox \
    firefox-langpacks


# Install Apps
dnf5 -y install gnome-tweaks gnome-extensions-app

# Install Gnome Extensions
dnf5 -y install gnome-shell-extension-appindicator \
              gnome-shell-extension-blur-my-shell \
              gnome-shell-extension-caffeine \
              gnome-shell-extension-dash-to-panel \
              gnome-shell-extension-just-perfection \
              gnome-shell-extension-pop-shell

# Disable welcome screen
cat > /etc/dconf/db/local.d/00-disable-gnome-tour <<EOF
[org/gnome/shell]
welcome-dialog-last-shown-version='$(rpm -qv gnome-shell | cut -d- -f3)'
EOF


# Update dconf
dconf update

# Install codecs
dnf5 -y swap ffmpeg-free ffmpeg --allowerasing


# Swap flatpak repos
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak remote-modify --no-filter --enable flathub


# Cleanup unused packages
dnf5 -y remove nvtop htop


# Grab the modules
git clone https://github.com/carbonux/onboarding /tmp/onboarding
rsync -av --keep-dirlinks /tmp/onboarding/rootcopy/* /
    # Add executable
    dnf5 -y install zenity
    cp `which zenity` /usr/lib/onboarding/onboardingWindow

git clone https://github.com/carbonux/wallpaper-cycler /tmp/wallpaper-cycler
rsync -av --keep-dirlinks /tmp/wallpaper-cycler/rootcopy/* /
