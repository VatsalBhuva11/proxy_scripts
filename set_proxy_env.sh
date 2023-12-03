#!/bin/bash

ADDRESS=$(sed "s/ADDRESS=\(.*\)/\1/" < <(grep "ADDRESS=.*" ${PWD}/proxy.conf.txt))
PORT=$(sed "s/PORT=\([0-9]*\)/\1/" < <(grep "PORT=[0-9]*" ${PWD}/proxy.conf.txt))
USERNAME=$(sed "s/USERNAME=\(.*\)/\1/" < <(grep "USERNAME=.*" ${PWD}/proxy.conf.txt))
PASSWORD=$(sed "s/PASSWORD=\(.*\)/\1/" < <(grep "PASSWORD=.*" ${PWD}/proxy.conf.txt))

# remove any extra/clutter exports of proxy
sed -i -r "/^[[:blank:]]*export[[:blank:]]+http\_proxy=.*/d" ~/.bashrc
sed -i -r "/^[[:blank:]]*export[[:blank:]]+https\_proxy=.*/d" ~/.bashrc

# append new proxy export
export http_proxy=http://$USERNAME:$PASSWORD@$ADDRESS:$PORT
export https_proxy=http://$USERNAME:$PASSWORD@$ADDRESS:$PORT

echo "export http_proxy=http://$USERNAME:$PASSWORD@$ADDRESS:$PORT" >> ~/.bashrc
echo "export https_proxy=http://$USERNAME:$PASSWORD@$ADDRESS:$PORT" >> ~/.bashrc
