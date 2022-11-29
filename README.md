# Aperture Photometry Tool

## Setup
Log onto the ubuntu machine that is running Guacamole.
Run the bootstrap script
```shell
curl -sL https://raw.githubusercontent.com/ADACS-Australia/aperture-photometry-tool/master/bootstrap.sh | sudo bash
```

## Creating users
Run the users script, providing as many users as necessary. It will create each user with a random password. Existing users will be skipped.

e.g. to create users `bob`, `bill`, `tim` and `tom`
```shell
curl -sL https://raw.githubusercontent.com/ADACS-Australia/aperture-photometry-tool/master/users.sh | sudo bash -s bob bill tim tom
```
The script will output the name and password of each user it creates. **These passwords should be temporary.**

Don't forget remind `bob`, `bill`, `tim` and `tom` to change their passwords when they first log in.

## Uploading/Downloading files
Open [Guacamole sidebar menu](https://guacamole.apache.org/doc/gug/using-guacamole.html#the-guacamole-menu) with `ctrl+alt+shift`.
Click on Shared Drive under Devices. Double click on files to download.
