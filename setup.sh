#!/bin/bash

#give all .sh files execution permission
chmod +x ${PWD}/*.sh

#add the path to the .bashrc file
echo "export PATH=\$PATH:${PWD}" >> ~/.bashrc

#source the .bashrc file
source ~/.bashrc

./proxy.conf.sh
