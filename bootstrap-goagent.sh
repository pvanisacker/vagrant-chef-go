#!/bin/bash

# Remove puppet & install all other packages
sudo apt-get -q -y autoremove puppet chef ruby
sudo apt-get -q update
sudo apt-get -q -y upgrade

sudo dpkg -i /vagrant/packages/chef_*.deb

cp -f /vagrant/adminorg-validator.pem /etc/chef/

cat << EOF > /etc/chef/client.rb
log_level				:info
log_location			STDOUT
validation_client_name	'adminorg-validator'
validation_key			'/etc/chef/adminorg-validator.pem'
chef_server_url			'https://chefserver.chef.com:443/organizations/adminorg'
enable_reporting		true
ssl_verify_mode			:verify_none
EOF

chef-client
