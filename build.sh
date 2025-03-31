#!/bin/bash

set -ouex pipefail

git clone https://github.com/bluefora/build-workstation:dev /tmp/build
rsync -av --keep-dirlinks /tmp/build/rootcopy/* /
bash /tmp/build.sh