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
WHITE='\e[0m'
YELLOW='\033[0;33m'

echo "Unsetting current env variables..."
unset HTTP_PROXY
unset HTTPS_PROXY
unset http_proxy
unset https_proxy

echo "Unsetting GitHub proxy globally..."

if [[ ! -f ~/.gitconfig ]]
then
	echo "Skipping unsetting from ~/.gitconfig (file not found)..."
else
	$(git config --global --unset https.proxy)
	$(git config --global --unset http.proxy)
	echo -e "${GREEN}Unset proxy from ${YELLOW}~/.gitconfig."
fi

BASHRC_PATH=~/.bashrc
COUNT=0

#setting IFS to an empty string will read the entire line at once, and not split it.
#COUNT variable to see if there is any EXPORT HTTP/HTTPS command set in ~/.bashrc
while IFS= read line; do
    ((COUNT+=1))
done < <(grep -P -i "^\s*export\s+(http_proxy|https_proxy|ftp_proxy|HTTP_PROXY|HTTPS_PROXY).*" "$BASHRC_PATH")
#The outer < is a standard input redirection operator, and the inner <(...) is the process substitution. Process substitution is needed here
#as the COUNT variable needs to persist across all the | operations.

echo $COUNT

# Use a while loop to read lines from the file
if [[ $COUNT -gt 0 ]];
then
	echo
	echo -e "${WHITE}GitHub proxy may also be configured in the ~/.bashrc file"
	echo "Allow to unset the http_proxy and https_proxy ENV variables?"
	echo "Note: This may affect the use of proxy in other apps."
	read -p "(y or n): " CHOICE

    # translate the CHOICE variable to lowercase and check if it is y or empty
	if [[ "$(echo $CHOICE | tr '[:upper:]' '[:lower:]')" = "y" || -z "$CHOICE" ]]
	then
		
        # -i: This option tells sed to edit the file in-place.
        # -r: This option enables extended regular expressions, allowing the use of + for "one or more occurrences" and other extended regex features.
		sed -i -r '/^[[:blank:]]*export[[:blank:]]+http_proxy/d' $BASHRC_PATH
		sed -i -r '/^[[:blank:]]*export[[:blank:]]+https_proxy/d' $BASHRC_PATH
		sed -i -r '/^[[:blank:]]*export[[:blank:]]+ftp_proxy/d' $BASHRC_PATH

        . /home/vbuntu/Desktop/Vatsal/Programming/proxy_scripts/scripts/unset_proxy_env.sh

		if [[ $? -eq 0 ]]
		then
			source $BASHRC_PATH
			echo -e "${GREEN}Unset proxy from ${YELLOW}$BASHRC_PATH ${GREEN}and env variables."
			echo "Successfully removed GitHub proxy requirements! You can now push/pull/clone etc. without a proxy."
			echo "Please restart this terminal session, or open a new terminal session for the changes to be made."
		else
			echo -e "${RED}Failed to unset proxy from $BASHRC_PATH"
		fi

	else
		echo -e "${RED}GitHub proxy is not fully unset and may hamper the proxy configuration of Git."
	fi
else
	echo
    echo -e "${GREEN}Successfully removed GitHub proxy requirements! You can now push/pull/clone etc. without a proxy."
    echo "Please restart this terminal session, or open a new terminal session for the changes to be made."
fi
