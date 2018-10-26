#!/bin/bash
# From https://stackoverflow.com/questions/6619277/how-to-get-the-logged-in-users-real-name-in-unix
if [ "Darwin" = $(uname) ]; then
    FULLNAME=$(id -P $USER | awk -F '[:]' '{print $8}')
else
    FULLNAME=$(getent passwd $USER | cut -d: -f5 | cut -d, -f1)
fi
echo $FULLNAME | tr -d '\n'

