#!/bin/bash

#give all .sh files execution permission in pwd
chmod +x $(dirname "${0}")/*.sh
chmod +x $(dirname "${0}")/scripts/*.sh

#add the path to the .bashrc file

if ! grep -q "export PATH=\$PATH:$(cd $(dirname ${0}) && pwd)" ~/.bashrc; then
    echo "export PATH=\$PATH:$(cd $(dirname ${0}) && pwd)" >> ~/.bashrc
fi
if ! grep -q "export PATH=\$PATH:$(cd $(dirname ${0}) && pwd)/scripts" ~/.bashrc; then
    echo "export PATH=\$PATH:$(cd $(dirname ${0}) && pwd)/scripts" >> ~/.bashrc
fi

#source the .bashrc file
source ~/.bashrc

$(dirname ${0})/scripts/proxy.conf.sh
