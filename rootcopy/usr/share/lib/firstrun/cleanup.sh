#!/bin/bash

# Swap to signed
if rpm-ostree status -b | grep ostree-unverified-registry; then
    # Rebase to signed image
    SIGN_URI=$(rpm-ostree status -b | grep -A1 "BootedDeployment:" | grep -v "BootedDeployment" | sed -E 's/.+ostree-unverified-registry:(.+)/ostree-image-signed:docker:\/\/\1/')
    echo "Signing installation - This will take a while"
    plymouth display-message --text="Signing installation - This will take a while" || true
    # shellcheck disable=SC2086
    rpm-ostree rebase $SIGN_URI
fi

# remove flatpak remote
if [[ flatpak remotes | grep fedora ]]; then
    flatpak remote-delete fedora --force
fi

rm /etc/bluefora.firstrun