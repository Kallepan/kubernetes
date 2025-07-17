#!/bin/bash

MODEL_URL="something"

# Move into the models directory
cd /mnt/models

# Setup git lfs
(. /etc/lsb-release &&
curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh |
env os=ubuntu dist="${DISTRIB_CODENAME}" bash)

apt-get install git-lfs

git lfs install

# Download the model
git clone "${MODEL_URL}" 
