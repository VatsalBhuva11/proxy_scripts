#!/bin/bash

ADDRESS=$(sed "s/ADDRESS=\(.*\)/\1/" < <(grep "ADDRESS=.*" $(dirname "${0}")/proxy.conf.txt))
PORT=$(sed "s/PORT=\([0-9]*\)/\1/" < <(grep "PORT=[0-9]*" $(dirname "${0}")/proxy.conf.txt))
USERNAME=$(sed "s/USERNAME=\(.*\)/\1/" < <(grep "USERNAME=.*" $(dirname "${0}")/proxy.conf.txt))
PASSWORD=$(sed "s/PASSWORD=\(.*\)/\1/" < <(grep "PASSWORD=.*" $(dirname "${0}")/proxy.conf.txt))

# remove any extra/clutter exports of proxy
sed -i -r "/^[[:blank:]]*export[[:blank:]]+http\_proxy=.*/d" ~/.bashrc
sed -i -r "/^[[:blank:]]*export[[:blank:]]+https\_proxy=.*/d" ~/.bashrc

# append new proxy export
export http_proxy=http://$USERNAME:$PASSWORD@$ADDRESS:$PORT
export https_proxy=http://$USERNAME:$PASSWORD@$ADDRESS:$PORT

echo "export http_proxy=http://$USERNAME:$PASSWORD@$ADDRESS:$PORT" >> ~/.bashrc
echo "export https_proxy=http://$USERNAME:$PASSWORD@$ADDRESS:$PORT" >> ~/.bashrc
