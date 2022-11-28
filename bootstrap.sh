#!/usr/bin/env bash
set -e
aptversion="v3.0.8"
appdir="/usr/local/share/applications"
logfile="${PWD}/bootstrap.log"

echo "--> Configuring server..."
# set timezone
timedatectl set-timezone Australia/Melbourne
echo "BOOTSTRAP LOG: $(date)\n" > "${logfile}"

# stop warning about upgrades
sed -i 's/Prompt=.*/Prompt=never/' /etc/update-manager/release-upgrades

# fix “Authentication is required to create a color profile/managed device”
cat << EOF > /etc/polkit-1/localauthority/50-local.d/45-allow-colord.pkla
[Allow Colord all Users]
Identity=unix-user:*
Action=org.freedesktop.color-manager.create-device;org.freedesktop.color-manager.create-profile;org.freedesktop.color-manager.delete-device;org.freedesktop.color-manager.delete-profile;org.freedesktop.color-manager.modify-device;org.freedesktop.color-manager.modify-profile
ResultAny=no
ResultInactive=no
ResultActive=yes

EOF

# turn off auto update
echo "--> Updating..."
echo "--> Updating..." >> "${logfile}"
apt-get remove -qy unattended-upgrades >> "${logfile}"
apt-get update -qy >> "${logfile}"
apt-get upgrade -qy >> "${logfile}"

# install csh, openjdk-11-jdk, ansible
echo "--> Installing dependencies..."
echo "--> Installing dependencies..." >> "${logfile}"
apt-get install -qy csh openjdk-11-jdk ansible >> "${logfile}"

echo "--> Installing APT..."
echo "--> Installing APT..." >> "${logfile}"
# download APT, untar
mkdir -p "${appdir}"
cd "${appdir}"
rm -f APT_${aptversion}.tar.gz
wget -q "http://web.ipac.caltech.edu/staff/laher/apt/APT_${aptversion}.tar.gz" >> "${logfile}"
tar -xvzf APT_${aptversion}.tar.gz >> "${logfile}"
rm -f APT_${aptversion}.tar.gz
# create .desktop file
cat << EOF > apt.desktop
[Desktop Entry]

Version=${aptversion}
Name=APT
GenericName=Aperture Photometry Tool
Comment=Aperture Photometry Tool (APT) is software for astronomical research, as well as for learning, visualizing and refining aperture-photometry analyses.

Exec=env APT_ARCH=linux APT_HOME=${appdir}/APT_${aptversion}/ ./APT.csh
Path=${appdir}/APT_${aptversion}/
Icon=${appdir}/APT_${aptversion}/resources/APT.icns

Terminal=false
StartupNotify=false

Type=Application
Categories=Application

EOF

# make executable
chmod +x apt.desktop

# place in skeleton so it appears on desktop for new users
cd /etc/skel
mkdir -p Desktop
cd Desktop
cp ${appdir}/apt.desktop .

#create shared drive folder, and softlink to skel
echo "--> Creating shared drive..."
echo "--> Creating shared drive..." >> "${logfile}"
mkdir -p "/srv/Shared Drive"
cd "/srv/Shared Drive"
chown guacd .
chgrp users .
chmod 775 .
chmod g+s .
cd /etc/skel/Desktop
ln -fs "/srv/Shared Drive" .

cd
echo "--> Configuring Guacamole..."
echo "--> Configuring Guacamole..." >> "${logfile}"
# add group="users" entry to unix-users-map.xml
sed -i 's/<group name="sudo">/<group name="users">/' /etc/guacamole/unix-user-mapping.xml

# enable shared drive unix-users-map.xml
cat <<-EOF > playbook.yml
- name: guacamole config
  hosts: all
  gather_facts: false
  become: true

  tasks:
  - blockinfile:
      path: /etc/guacamole/unix-user-mapping.xml
      marker: "<!-- {mark} ANSIBLE MANAGED BLOCK -->"
      insertbefore: "</config>"
      block: |
        <param name='enable-drive' value='true' />
        <param name='drive-path' value='/srv/Shared Drive' />"


EOF
ansible-playbook -c local -i localhost, playbook.yml >> "${logfile}"
rm -f playbook.yml
