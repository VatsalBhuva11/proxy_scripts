<<comment
__     ______    _   _
\ \   / / __ )  / | / |
 \ \ / /|  _ \  | | | |
  \ V / | |_) | | | | |
   \_/  |____/  |_| |_|
comment
#!/bin/bash

# env http_proxy and https_proxy when set do not let it clone.
# setting http_proxy and https_proxy in env (~/.bashrc) lets us clone
# do not require setting ~/.gitconfig
# setting in ~/.gitconfig without setting env also works .

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'

echo "Setting proxy for Git..."

if [[ ! -f $(dirname ${0})/proxy.conf.txt ]]
then
    echo -e "${RED}Please run proxy.conf.sh first to set up your proxy credentials."
    exit 1
fi

# < < is a process substitution operator. 
# it temporarily creates a file from the output of the command, and passes that as an input to the other command
# using just < would have treated the output of the command as a file name, and tried to open it for reading, which would have failed.
# \(...\) creates a capturing group in the sed command.
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

if [[ $FLAG == "y" ]]
then
	
	echo "Adding proxy to ~/.gitconfig..."
	$(git config --global http.proxy http://$USERNAME:$PASSWORD@$ADDRESS:$PORT)
	$(git config --global https.proxy http://$USERNAME:$PASSWORD@$ADDRESS:$PORT)

    if [[ $? -eq 0 ]]
    then
        echo -e "${GREEN}Successfully set proxy in ${YELLOW}~/.gitconfig!"
    else    
        echo -e "${RED}Failed to add proxy to ${YELLOW}~/.gitconfig!"
        exit 1
    fi

	. $(dirname ${0})/set_proxy_env.sh

else
	$(git config --global http.proxy http://$ADDRESS:$PORT)
	$(git config --global https.proxy http://$ADDRESS:$PORT)

    if [[ $? -eq 0 ]]
    then
        echo -e "${GREEN}Successfully set proxy in ${YELLOW}~/.gitconfig!"
    else    
        echo -e "${RED}Failed to add proxy to ${YELLOW}~/.gitconfig!"
        exit 1
    fi
    
	. $(dirname ${0})/set_proxy_env.sh
fi


if [[ $? -eq 0 ]]
then
	echo
	if [[ $? -eq 0 ]]
	then
		echo -e "${GREEN}Please restart this terminal session, or open a new terminal session for the changes to be made."
        exit 0
	else
		echo -e "${RED}Failed to setup git proxy. Please try again later"
        exit 1
	fi
else
	echo -e "${RED}Some error occurred while setting up the proxy. Try again"
	exit 1
fi
