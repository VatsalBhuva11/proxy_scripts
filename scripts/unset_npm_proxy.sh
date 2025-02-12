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

echo "Unsetting npm proxy globally..."

if [[ ! -f ~/.npmrc ]]
then
	echo "Skipping unsetting from ~/.npmrc (file not found)..."
else
	npm config rm proxy
	npm config rm https-proxy
	echo -e "${GREEN}Unset proxy from ${YELLOW}~/.npmrc."
fi

BASHRC_PATH=~/.bashrc
COUNT=0

<<comment
previous logic:
grep -P "^\s*export\s+(http|https|ftp)_proxy.*" "$BASHRC_PATH" | while IFS= read -r line ; do
        ((COUNT+=1))
done
comment

#setting IFS to an empty string will read the entire line at once, and not split it.
#COUNT variable to see if there is any EXPORT HTTP/HTTPS command set in ~/.bashrc
while IFS= read line; do
    ((COUNT+=1))
done < <(grep -P -i "^\s*export\s+(http_proxy|https_proxy|ftp_proxy).*" "$BASHRC_PATH")
#The outer < is a standard input redirection operator, and the inner <(...) is the process substitution. Process substitution is needed here
#as the COUNT variable needs to persist across all the | operations.

<<comment
Can also use loop for removing any kind of proxy. In this case though, remove only http/https individually.
grep -P -i "^\s*export\s+(http|https|ftp)_proxy.*" "$BASHRC_PATH" | while IFS= read line ; do
    # Escape special characters in the line
    escaped_line=$(printf '%s\n' "$line" | sed 's/[\/&]/\\&/g')
    # Use sed to delete the line in place
    sed -i "/^$escaped_line/d" "$BASHRC_PATH"
done
comment


# Use a while loop to read lines from the file
if [[ $COUNT -gt 0 ]];
then
	echo
	echo -e "${WHITE}npm proxy may also be configured in the ~/.bashrc file"
	echo "Allow to unset the http_proxy and https_proxy ENV variables?"
	echo "Note: This may affect the use of proxy in other apps."
	read -p "(y or n): " CHOICE

    if [[ "$(echo $CHOICE | tr '[:upper:]' '[:lower:]')" = "y" || -z "$CHOICE" ]]
	then
		
		# Individually remove the proxy. can also use loop as stated in the comment above.
		sed -i -r '/^[[:blank:]]*export[[:blank:]]+http_proxy/d' $BASHRC_PATH
		sed -i -r '/^[[:blank:]]*export[[:blank:]]+https_proxy/d' $BASHRC_PATH
		sed -i -r '/^[[:blank:]]*export[[:blank:]]+ftp_proxy/d' $BASHRC_PATH

		. /home/vbuntu/Desktop/Vatsal/Programming/proxy_scripts/scripts/unset_proxy_env.sh

        # if previous command executed properly.
		if [[ $? -eq 0 ]]
		then
			source $BASHRC_PATH
			echo -e "${GREEN}Unset proxy from ${YELLOW}$BASHRC_PATH ${GREEN}and env variables."
			echo "Successfully removed npm proxy requirements! You can now install npm libraries without a proxy."
			echo "Please restart this terminal session, or open a new terminal session for the changes to be made."
			return 0
		else
			echo -e "${RED}Failed to unset proxy from ${YELLOW}$BASHRC_PATH"
			return 1
		fi

	else
		echo -e "${RED}npm proxy is not fully unset and may hamper the usage of npm"
		return
	fi
else
	echo
	echo -e "${GREEN}Successfully removed npm proxy requirements! You can now install npm libraries without a proxy."
	echo "Please restart this terminal session, or open a new terminal session for the changes to be made."
	return 0
fi





