#!/bin/bash

# Remove puppet & install all other packages
sudo apt-get -q -y autoremove puppet chef ruby
sudo apt-get -q update
sudo apt-get -q -y upgrade

CHEF_SERVER_PACKAGE_NAME="chef-server-core"
dpkg -s $CHEF_SERVER_PACKAGE_NAME
RESULT=`echo $?`
if [[ "$RESULT" == "1" ]]; then
    # Install chef
    sudo dpkg -i /vagrant/packages/${CHEF_SERVER_PACKAGE_NAME}_*.deb

    # Configure chef
    sudo chef-server-ctl reconfigure
    sudo chef-server-ctl user-create admin admin admin admin@admin.com changeme --filename /root/admin.pem
    sudo cp -f /root/admin.pem /vagrant/
    sudo chef-server-ctl org-create adminorg Adminorg --association_user admin --filename /root/adminorg-validator.pem
    sudo cp -f /root/adminorg-validator.pem /vagrant/

    # Install chef packages
    sudo chef-server-ctl install opscode-manage
    sudo opscode-manage-ctl reconfigure
    sudo chef-server-ctl reconfigure

    sudo chef-server-ctl install opscode-reporting
    sudo opscode-reporting-ctl reconfigure
    sudo chef-server-ctl reconfigure
fi