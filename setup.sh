#!/bin/bash

#give all .sh files execution permission in pwd
chmod +x ${PWD}/*.sh

#add the path to the .bashrc file

if ! grep -q "export PATH=\$PATH:${PWD}" ~/.bashrc; then
    echo "export PATH=\$PATH:${PWD}" >> ~/.bashrc
fi

#source the .bashrc file
source ~/.bashrc

./proxy.conf.sh
