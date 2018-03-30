#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive

# update sources
sudo apt-get -qq update

# tools
sudo apt-get install -y wget curl build-essential
sudo apt-get install -y zlib1g-dev libssl-dev
sudo apt-get install -y libreadline-gplv2-dev
sudo apt-get install -y libxml2 libxml2-dev libxslt1-dev
sudo apt-get install -y python-software-properties
sudo apt-get install -y imagemagick
sudo apt-get install -y openjdk-8-jre-headless
sudo apt-get install -y libpng-dev libjpeg-dev
sudo apt-get install -y libsasl2-dev

# mysql
sudo apt-get install -y mysql-server libmysqlclient-dev

# mongodb
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv 7F0CEB10
echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' | sudo tee /etc/apt/sources.list.d/mongodb.list
sudo apt-get -qq update
sudo apt-get install -y mongodb

# redis
sudo apt-get install -y redis-server

# beanstalkd
sudo apt-get install -y beanstalkd

# elasticsearch
if [[ -z `dpkg -l | grep elasticsearch` ]]; then
  wget --no-check-certificate https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-6.1.1.deb
  sudo dpkg -i elasticsearch-6.1.1.deb && rm elasticsearch-6.1.1.deb
fi

# nodejs
sudo apt-get install -y nodejs

# yarn
sudo apt-get install -y yarn

# phantomjs
sudo apt-get install -y phantomjs
