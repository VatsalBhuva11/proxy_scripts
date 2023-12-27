<<comment
__     ______    _   _
\ \   / / __ )  / | / |
 \ \ / /|  _ \  | | | |
  \ V / | |_) | | | | |
   \_/  |____/  |_| |_|
comment

#!/bin/bash

echo "Unsetting GitHub proxy globally..."

if [[ ! -f ~/.gitconfig ]]
then
	echo "Skipping unsetting from ~/.gitconfig (file not found)..."
else
	$(git config --global --unset https.proxy)
	$(git config --global --unset http.proxy)
	. ./unset_proxy_env.sh
	echo "Unset proxy from environment variables and ~/.gitconfig."
fi

BASHRC_PATH=~/.bashrc
COUNT=0

#setting IFS to an empty string will read the entire line at once, and not split it.
#COUNT variable to see if there is any EXPORT HTTP/HTTPS command set in ~/.bashrc
while IFS= read line; do
    ((COUNT+=1))
done < <(grep -P "^\s*export\s+(http_proxy|https_proxy|ftp_proxy).*" "$BASHRC_PATH")
#The outer < is a standard input redirection operator, and the inner <(...) is the process substitution. Process substitution is needed here
#as the COUNT variable needs to persist across all the | operations.


# Use a while loop to read lines from the file
if [[ $COUNT -gt 0 ]];
then
	echo
	echo "GitHub proxy may also be configured in the ~/.bashrc file"
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

		if [[ $? -eq 0 ]]
		then
			. $(dirname ${0})/unset_proxy_env.sh
			echo "Unset proxy from $BASHRC_PATH"
			echo "Successfully removed GitHub proxy requirements! You can now push/pull/clone etc. without a proxy."
			exit 0
		else
			echo "Failed to unset proxy from $BASHRC_PATH"
			exit 1
		fi

	else
		echo "GitHub proxy is not fully unset and may hamper the proxy configuration of Git."
		exit
	fi
else
	echo
	echo "Successfully removed Git proxy requirements! You can now push/pull/clone etc without a proxy."
	echo "Please restart this terminal session, or open a new terminal session for the changes to be made."
	exit 0
fi
