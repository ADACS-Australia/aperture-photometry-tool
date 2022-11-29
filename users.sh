#!/usr/bin/env bash

# script for generating user+psswd combos, making sure theyre in "users" group
# remember to tell students to change password immediately

for user in $@; do
  pswd="$(pwgen -cn 12 1)"
  adduser --quiet --disabled-password --gecos "" $user
  if [ "$?" -eq "0" ]; then
    usermod $user -a -G users
    echo "${user}:${pswd}" | chpasswd
    echo $user $pswd
  fi
done
