#!/bin/bash

GREEN='\033[0;32m'
RED='\033[0;31m'
WHITE='\e[0m'

if [[ ! -f $(dirname ${0})/proxy.conf.txt ]]
then
    echo -e "${RED}Please run proxy.conf.sh first to set up your proxy credentials."
    exit 1
fi

ADDRESS=$(grep "ADDRESS=.*" $(dirname ${0})/proxy.conf.txt | sed "s/ADDRESS=\(.*\)/\1/")
PORT=$(grep "PORT=[0-9]*" $(dirname ${0})/proxy.conf.txt | sed "s/PORT=\([0-9]*\)/\1/")
USERNAME=$(grep "USERNAME=.*" $(dirname ${0})/proxy.conf.txt | sed "s/USERNAME=\(.*\)/\1/")
PASSWORD=$(grep "PASSWORD=.*" $(dirname ${0})/proxy.conf.txt | sed "s/PASSWORD=\(.*\)/\1/")

# remove any extra/clutter exports of proxy
sed -i -r "/^[[:blank:]]*export[[:blank:]]+http\_proxy=.*/d" ~/.bashrc
sed -i -r "/^[[:blank:]]*export[[:blank:]]+https\_proxy=.*/d" ~/.bashrc

if [[ ! -z "$USERNAME" && ! -z "$PASSWORD" ]]
then    
    FLAG="y"
else
    FLAG="n"
fi

echo -e "${WHITE}Setting proxy in ~/.bashrc and environment variables..."
# append new proxy export
if [[ $FLAG == "y" ]]
then
    export http_proxy=http://$USERNAME:$PASSWORD@$ADDRESS:$PORT
    export https_proxy=http://$USERNAME:$PASSWORD@$ADDRESS:$PORT

    echo "export http_proxy=http://$USERNAME:$PASSWORD@$ADDRESS:$PORT" >> ~/.bashrc
    echo "export https_proxy=http://$USERNAME:$PASSWORD@$ADDRESS:$PORT" >> ~/.bashrc
else
    export http_proxy=http://$ADDRESS:$PORT
    export https_proxy=http://$ADDRESS:$PORT

    echo "export http_proxy=http://$ADDRESS:$PORT" >> ~/.bashrc
    echo "export https_proxy=http://$ADDRESS:$PORT" >> ~/.bashrc
fi

if [[ $? -eq 0 ]]
then
    echo -e "${GREEN}Successfully set proxy in ${YELLOW}~/.bashrc!"
else    
    echo -e "${RED}Failed to add proxy to ${YELLOW}~/.bashrc!"
    exit 1
fi