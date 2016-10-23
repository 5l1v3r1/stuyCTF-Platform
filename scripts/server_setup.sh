#!/bin/bash

export VAGRANT_PATH=/home/vagrant

# Must run setup as root
if [[ $(id -u) -ne 0 ]] ; then echo "Please run the setup script as root." ; exit 1 ; fi

# Mimic Vagrant Development environment
if [[ $(pwd) == *"/scripts" ]]; then
    mkdir -p ${VAGRANT_PATH}
    cd ..
    ln -s $(pwd)/api ${VAGRANT_PATH}
    ln -s $(pwd)/web ${VAGRANT_PATH}
    ln -s $(pwd)/scripts ${VAGRANT_PATH}
    ln -s $(pwd)/config ${VAGRANT_PATH}
else
    echo "Server setup script must be run in the stuyCTF-Platform/scripts folder!"
    exit
fi

# Updates
apt-get -y update
apt-get -y upgrade

# CTF-Platform Dependencies
apt-get -y install python3-pip
apt-get -y install nginx
apt-get -y install mongodb
apt-get -y install gunicorn
apt-get -y install git
apt-get -y install libzmq-dev
apt-get -y install nodejs-legacy
apt-get -y install npm
apt-get -y install libclosure-compiler-java
apt-get -y install ruby-dev
apt-get -y install dos2unix
apt-get -y install tmux
apt-get -y install openjdk-7-jdk
apt-get -y install php5-cli php5-fpm

npm install -g coffee-script
npm install -g react-tools
npm install -g jsxhint
npm install -g coffee-react

pip3 install -r ${VAGRANT_PATH}/api/requirements.txt

# Jekyll
gem install jekyll -v 2.5.3

# Configure Environment
echo "PATH=$PATH:${VAGRANT_PATH}/scripts" >> /etc/profile
echo "export VAGRANT_PATH=${VAGRANT_PATH}" >> /etc/profile

# Configure Nginx
cp ${VAGRANT_PATH}/config/ctf.nginx /etc/nginx/sites-enabled/ctf
rm /etc/nginx/sites-enabled/default
mkdir -p /srv/http/ctf
mkdir -p /src/http/php
service nginx restart
