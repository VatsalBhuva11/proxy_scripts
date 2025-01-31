<<comment
__     ______    _   _
\ \   / / __ )  / | / |
 \ \ / /|  _ \  | | | |
  \ V / | |_) | | | | |
   \_/  |____/  |_| |_|
comment
#!/bin/bash

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'

echo "Setting proxy for npm..."

if [[ ! -f $(dirname ${0})/proxy.conf.txt ]]
then
    echo -e "${RED}Please run proxy.conf.sh first to set up your proxy credentials."
    return 1
fi

ADDRESS=$(grep "ADDRESS=.*" $(dirname ${0})/proxy.conf.txt | sed "s/ADDRESS=\(.*\)/\1/")
PORT=$(grep "PORT=[0-9]*" $(dirname ${0})/proxy.conf.txt | sed "s/PORT=\([0-9]*\)/\1/")
USERNAME=$(grep "USERNAME=.*" $(dirname ${0})/proxy.conf.txt | sed "s/USERNAME=\(.*\)/\1/")
PASSWORD=$(grep "PASSWORD=.*" $(dirname ${0})/proxy.conf.txt | sed "s/PASSWORD=\(.*\)/\1/")

if [[ ! -z "$USERNAME" && ! -z "$PASSWORD" ]]
then    
    FLAG="y"
else
    FLAG="n"
fi

echo "Adding proxy to ~/.npmrc ..."
if [[ $FLAG == "y" ]]
then
	
	npm config set proxy http://$USERNAME:$PASSWORD@$ADDRESS:$PORT
	npm config set https-proxy http://$USERNAME:$PASSWORD@$ADDRESS:$PORT

    if [[ $? -eq 0 ]]
    then
        echo -e "${GREEN}Successfully set proxy in ${YELLOW}~/.npmrc!"
    else    
        echo -e "${RED}Failed to add proxy to ${YELLOW}~/.npmrc!"
        return 1
    fi

    . $(dirname ${0})/set_proxy_env.sh

elif [[ $FLAG == "n"  ]]
then
	npm config set proxy http://$ADDRESS:$PORT
	npm config set https-proxy http://$ADDRESS:$PORT


    if [[ $? -eq 0 ]]
    then
        echo -e "${GREEN}Successfully set proxy in ${YELLOW}~/.npmrc!"
    else    
        echo -e "${RED}Failed to add proxy to ${YELLOW}~/.npmrc!"
        return 1
    fi

    . $(dirname ${0})/set_proxy_env.sh
else
	echo -e "${RED}Invalid input. Please type y/Y/n/N"
	return 1
fi


if [[ $? -eq 0 ]]
then
	echo
	if [[ $? -eq 0 ]]
	then
		echo -e "${GREEN}Please restart this terminal session, or open a new terminal session for the changes to be made."
        return 0
	else
		echo -e "${RED}Failed to add proxy to ${YELLOW}~/.npmrc. ${RED}Please try again later"
        return 1
	fi
else
	echo -e "${RED}Some error occurred while setting up the proxy. Try again"
	return 1
fi
