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

echo "Setting proxy for Git..."

# < < is a process substitution operator. 
# it temporarily creates a file from the output of the command, and passes that as an input to the other command
# using just < would have treated the output of the command as a file name, and tried to open it for reading, which would have failed.
# \(...\) creates a capturing group in the sed command.
ADDRESS=$(grep "ADDRESS=.*" $(dirname ${0})/proxy.conf.txt | sed "s/ADDRESS=\(.*\)/\1/")
PORT=$(grep "PORT=[0-9]*" $(dirname ${0})/proxy.conf.txt | sed "s/PORT=\([0-9]*\)/\1/")
USERNAME=$(grep "USERNAME=.*" $(dirname ${0})/proxy.conf.txt | sed "s/USERNAME=\(.*\)/\1/")
PASSWORD=$(grep "PASSWORD=.*" $(dirname ${0})/proxy.conf.txt | sed "s/PASSWORD=\(.*\)/\1/")

[[ ${#USERNAME} -gt 0 && ${#PASSWORD} -gt 0 ]] && FLAG="y" || "n"


if [[ $FLAG == "y" ]]
then
	if [[ ! -f $(dirname ${0})/proxy.conf.txt ]]
	then
		echo "Please run proxy.conf.sh first to set up your proxy credentials."
		exit 1
	fi
	
	echo "Adding proxy to ~/.gitconfig ..."
	$(git config --global http.proxy http://$USERNAME:$PASSWORD@$ADDRESS:$PORT)
	$(git config --global https.proxy http://$USERNAME:$PASSWORD@$ADDRESS:$PORT)

	. $(dirname ${0})/set_proxy_env.sh

else
	$(git config --global http.proxy http://$ADDRESS:$PORT)
	$(git config --global https.proxy http://$ADDRESS:$PORT)
fi


if [[ $? -eq 0 ]]
then
	echo
	if [[ $? -eq 0 ]]
	then
		echo "Successfully set git proxy!"
		echo "Please restart this terminal session, or open a new terminal session for the changes to be made."
	else
		echo "Failed to add proxy to ~/.gitconfig. Please try again later"
	fi
else
	echo "Some error occurred while setting up the proxy. Try again"
	exit 1
fi