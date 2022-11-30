# Aperture Photometry Tool
Instructions for setting up a shared machine on Nectar for students to access the Aperture Photometry Tool (APT).

We will use the `R-Studio` Nectar Application, since it already has a remote desktop (Guacamole) configuration we can make use of.

## Create
1. On the Nectar dashboard go to `Applications -> Browse -> Browse Local` and search for `R-Studio`.
2. Press `quick deploy` and follow the instructions. (Recommended flavour for a class of ~30 is `m3.large`, maybe even `m3.xlarge`)
3. Press `Deploy this environment` and wait a few minutes for the instance to be created and set up.
4. Go to your machine's chosen URL and select Remote Desktop. Sign in with the username and password you chose in step 2.

## Setup
Once you are logged in to the machine, run the bootstrap script to configure and install APT
```shell
curl -sL https://raw.githubusercontent.com/ADACS-Australia/aperture-photometry-tool/master/bootstrap.sh | sudo bash
```

## Creating users
Unfortunately there's no handy signup process for new users (yet). You'll have to manually create user + password combinations. The `users.sh` script makes this a bit easier for you. You can provide as many usernames as necessary and it will create each user with a random password. Existing users will be skipped.

e.g. to create users `bob`, `bill`, `tim` and `tom`
```shell
curl -sL https://raw.githubusercontent.com/ADACS-Australia/aperture-photometry-tool/master/users.sh | sudo bash -s bob bill tim tom
```
The script will output the name and password of each user it creates, which you will then have to manually give to each person. **These passwords should be temporary.**

Don't forget to remind `bob`, `bill`, `tim` and `tom` to change their passwords when they first log in.

## Uploading/Downloading files
Open [Guacamole sidebar menu](https://guacamole.apache.org/doc/gug/using-guacamole.html#the-guacamole-menu) with `ctrl+alt+shift`.
Click on Shared Drive under Devices. Double click on files to download.

Anyone can upload files, however they will by default only be readable/writable by the `guacd` user. An admin will have to manually change the file permissions. e.g.
```shell
sudo chmod g+r <file>
```
