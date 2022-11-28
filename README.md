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

Don't forget remind `bob`, `bill`, `tim` and `tom` to change their passwords when they first log in.
