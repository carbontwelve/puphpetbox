#!/bin/bash

# installs nodejs/npm

echo '!!! INSTALL NODE EXEC ONCE !!! '

curl -sL https://deb.nodesource.com/setup | sudo bash -

sudo apt-get install -y nodejs

echo '!!! /INSTALL NODE EXEC ONCE !!! '
