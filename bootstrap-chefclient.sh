#!/bin/bash

# Remove puppet & install all other packages
sudo apt-get -q -y autoremove puppet chef ruby
sudo apt-get -q update
sudo apt-get -q -y upgrade

sudo dpkg -i /vagrant/packages/chefdk_*.deb

sudo -u vagrant /vagrant/bootstrap-chefclient-splunk.sh