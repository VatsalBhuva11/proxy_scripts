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

echo "Set up your proxy credentials (if your proxy requires authentication)."
read -p "Enter proxy address (eg: 111.22.3.4): " ADDRESS
read -p "Enter proxy port (eg: 8080): " PORT
# -z flag checks if the string is empty
if [[ -z "$ADDRESS"  ||  -z "$PORT" ]]
then
    echo "Proxy address and port cannot be empty."
    exit 1
fi
echo
echo "Leave the fields as blank if your proxy do not require authentication."
echo "For the following steps, please use the url-encoded values if any character is present in the string: "
ENCODING_FILE_PATH=$(dirname ${0})/urlencoding.txt
echo "--------------------------------------------------------------"
sed 's/("\([^"]*\)")/\1/' $ENCODING_FILE_PATH | awk '{printf "%-25s %-20s %s\n", $1, $2, $3}'
echo "--------------------------------------------------------------"
echo
read -p "Enter username: " username
read -s -p "Enter password: " password

FILE=$(dirname ${0})/proxy.conf.txt

echo "ADDRESS=$address" > $FILE
echo "PORT=$port" >> $FILE
echo "USERNAME=$username" >> $FILE
echo "PASSWORD=$password" >> $FILE
echo

if [[ $? -eq 0 ]]
then
    echo -e "${GREEN}Successfully set proxy credentials!"
else
    echo -e "${RED}Failed to set proxy credentials!"
fi
