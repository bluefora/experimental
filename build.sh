#!/bin/bash

set -ouex pipefail

git clone -b ${BRANCH:=main} https://github.com/bluefora/build-workstation /tmp/build
rsync -av --keep-dirlinks /tmp/build/rootcopy/* /
bash /tmp/build/build.sh