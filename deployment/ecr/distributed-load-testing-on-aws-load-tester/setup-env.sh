#!/bin/bash

set -eu

unset PREFIX
export NVM_DIR="/root/.nvm"
mkdir -p "$NVM_DIR"
curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
. $NVM_DIR/nvm.sh
nvm install 16.15.0
npm install -g typescript yarn


echo "Configuring git"
git config --global credential.helper "store --file /root/.git-credentials"

# Set github credentials to the credentials file. Make sure tracing is disabled to keep secrets from log file.
set +x
echo "https://oauth2:${GHTOKEN}@github.com" > /root/.git-credentials

mkdir -p /root/repo
cd /root/repo
git clone ${GHREPO} .
/tmp/setup.sh