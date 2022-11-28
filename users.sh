#!/usr/bin/env bash

# script for generating user+psswd combos, making sure theyre in "users" group
# remember to tell students to change password immediately

for user in $@; do
  pswd="$(pwgen -cn 10 1)"
  useradd -m $user -g users -p "$(mkpasswd ${pswd} -S ss)"
  echo $user $pswd
done
