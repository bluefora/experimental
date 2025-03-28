#!/bin/bash

set -ouex pipefail

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

# Update release file
sed -i -e 's/ID=silverblue/ID=expirimental/g' /usr/lib/os-release
sed -i -e 's/Silverblue/Carbonux/g' /usr/lib/os-release
sed -i -e 's/Fedora Linux 41 (Expirimental Edition)/Carbonux Linux 41 (Workstation Edition)/g' /usr/lib/os-release
sed -i -e 's/DEFAULT_HOSTNAME="fedora"/DEFAULT_HOSTNAME="carbonux"/g' /usr/lib/os-release

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

# Dconf stuff
cat > /etc/dconf/db/local.d/00-disable-gnome-tour <<EOF
[org/gnome/shell]
welcome-dialog-last-shown-version='$(rpm -qv gnome-shell | cut -d- -f3)'
EOF

dconf update

# Install codecs
dnf5 -y swap ffmpeg-free ffmpeg --allowerasing


# Swap flatpak repos
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak remote-modify --no-filter --enable flathub

dnf5 -y install zenity
cp `which zenity` /usr/lib/onboarding/onboardingWindow


# Cleanup unused packages
dnf5 -y remove nvtop htop


# Grab the submodules
git clone https://github.com/carbonux/onboarding /tmp/onboarding
cp -r /tmp/onboarding/rootcopy/* /