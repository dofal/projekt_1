#!/bin/sh
# xdofek02 Jiří Dofek
# 12.03.2023

export POSIXLY_CORRECT=yes
export LC_ALL=C

# Script started, let's get user info to log

date=$(date)
user=$(whoami)

# Now we have informations about user, let's check for arguments

# User passed -h argument - let's provide him help
if [ "$1" == "-h" ]
    then echo "hello \nworld"
fi
# file=$1
# nano "$file"
echo "testing output: date:$date, user:$user"
