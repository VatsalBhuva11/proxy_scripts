#!/bin/bash

unset http_proxy
unset https_proxy
unset HTTP_PROXY
unset HTTPS_PROXY

# remove any extra/clutter exports of proxy
sed -i -r "/^[[:blank:]]*export[[:blank:]]+http\_proxy=.*/d" ~/.bashrc
sed -i -r "/^[[:blank:]]*export[[:blank:]]+https\_proxy=.*/d" ~/.bashrc
sed -i -r "/^[[:blank:]]*export[[:blank:]]+HTTP\_PROXY=.*/d" ~/.bashrc
sed -i -r "/^[[:blank:]]*export[[:blank:]]+HTTPS\_PROXY=.*/d" ~/.bashrc
