#!/bin/bash

set -ouex pipefail

git clone -b dev https://github.com/bluefora/build-workstation /tmp/build
rsync -av --keep-dirlinks /tmp/build/rootcopy/* /
bash /tmp/build.sh