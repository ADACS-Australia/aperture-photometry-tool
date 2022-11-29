#!/usr/bin/env bash

# script for generating user+psswd combos, making sure theyre in "users" group
# remember to tell students to change password immediately

for user in $@; do
  pswd="$(pwgen -cn 10 1)"
  adduser --quiet --disabled-password --gecos "" $user
  if [ "$?" -eq "0" ]; then
    echo "${user}:${pswd}" | chpasswd
    echo $user $pswd
  fi
done
