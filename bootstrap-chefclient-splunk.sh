#!/bin/bash

# Configure editor
echo "export EDITOR=\"vim\"" >> ~/.bashrc

# Configure knife
mkdir -p /home/vagrant/.chef/trusted_certs/
mkdir -p /home/vagrant/chef-repo

cp -f /vagrant/admin.pem /home/vagrant/.chef/
cp -f /vagrant/adminorg-validator.pem /home/vagrant/.chef/

cat << EOF > /home/vagrant/.chef/knife.rb
log_level				:info
log_location			STDOUT
node_name				'admin'
client_key				'/home/vagrant/.chef/admin.pem'
validation_client_name	'adminorg-validator'
validation_key			'/home/vagrant/.chef/adminorg-validator.pem'
chef_server_url			'https://chefserver.chefsplunk.com:443/organizations/adminorg'
syntax_check_cache_path	'/home/vagrant/.chef/syntax_check_cache'
cookbook_path			["/home/vagrant/chef-repo/cookbooks"]
EOF

knife ssl fetch

# Download & install cookbooks
mkdir -p chef-repo/cookbooks

knife cookbook site download chef-vault
tar -xvf chef-vault-*.gz -C chef-repo/cookbooks
knife cookbook upload chef-vault

rm -rf chef_splunk-*.gz
knife cookbook site download chef-splunk
tar -xvf chef-splunk-*.gz -C chef-repo/cookbooks
knife cookbook upload chef-splunk
