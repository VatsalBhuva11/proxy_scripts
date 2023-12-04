#!/bin/bash

#give all .sh files execution permission in pwd
chmod +x $(dirname "${0}")/*.sh

#add the path to the .bashrc file

if ! grep -q "export PATH=\$PATH:$(dirname ${0})" ~/.bashrc; then
    echo "export PATH=\$PATH:$(dirname ${0})" >> ~/.bashrc
fi

#source the .bashrc file
source ~/.bashrc

./proxy.conf.sh
