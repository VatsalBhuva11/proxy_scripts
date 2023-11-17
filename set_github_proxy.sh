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

ADDRESS=$(sed "s/ADDRESS=\(.*\)/\1/" < <(grep "ADDRESS=.*" $(dirname "${0}")/proxy.conf.txt))
PORT=$(sed "s/PORT=\([0-9]*\)/\1/" < <(grep "PORT=[0-9]*" $(dirname "${0}")/proxy.conf.txt))
USERNAME=$(sed "s/USERNAME=\(.*\)/\1/" < <(grep "USERNAME=.*" $(dirname "${0}")/proxy.conf.txt))
PASSWORD=$(sed "s/PASSWORD=\(.*\)/\1/" < <(grep "PASSWORD=.*" $(dirname "${0}")/proxy.conf.txt))

[[ ${#USERNAME} -gt 0 && ${#PASSWORD} -gt 0 ]] && FLAG="y" || "n"


if [[ $FLAG == "y" ]]
then
	if [[ ! -f $(dirname ${0})/proxy.conf.txt ]]
	then
		echo "Please run proxy.conf.sh first to set up your proxy credentials."
		exit 1
	fi
	USERNAME=$(sed "s/USERNAME=\(.*\)/\1/" < <(grep "USERNAME=.*" $(dirname "${0}")/proxy.conf.txt))
	PASSWORD=$(sed "s/PASSWORD=\(.*\)/\1/" < <(grep "PASSWORD=.*" $(dirname "${0}")/proxy.conf.txt))
	echo "Adding proxy to ~/.gitconfig ..."
	$(git config --global http.proxy http://$USERNAME:$PASSWORD@$ADDRESS:$PORT)
	$(git config --global https.proxy http://$USERNAME:$PASSWORD@$ADDRESS:$PORT)

	# remove any extra/clutter exports of proxy
	sed -i -r "/^[[:blank:]]*export[[:blank:]]+http\_proxy=.*/d" ~/.bashrc
	sed -i -r "/^[[:blank:]]*export[[:blank:]]+https\_proxy=.*/d" ~/.bashrc

	# append new proxy export
	echo "export http_proxy=http://$USERNAME:$PASSWORD@$ADDRESS:$PORT" >> ~/.bashrc
	echo "export https_proxy=http://$USERNAME:$PASSWORD@$ADDRESS:$PORT" >> ~/.bashrc

elif [[ $FLAG == "n"  ]]
then
	$(git config --global http.proxy http://$ADDRESS:$PORT)
	$(git config --global https.proxy http://$ADDRESS:$PORT)
else
	echo "Invalid input. Please type y/Y/n/N"
	exit 1
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
