#!/bin/bash
sudo apt -y update
sudo apt install -y awscli
sudo mkdir -p /etc/chef
sudo curl -LO https://www.chef.io/chef/install.sh
sudo bash install.sh
sudo aws s3 cp s3://chefpemfiles/"${chef_user_pem}" /etc/chef/gmanal.pem
sudo aws s3 cp s3://chefpemfiles/"${chef_organization_pem}" /etc/chef/maplelabs123-validator.pem
sudo knife ssl fetch -s "${central_chef_server_url}"
sudo echo "log_level       :info
log_location     STDOUT
chef_server_url '${central_chef_server_url}'
trusted_certs_dir '/root/.chef/trusted_certs'
ssl_verify_mode  :verify_none" >> /etc/chef/client.rb
sudo chef-client -S "${central_chef_server_url}" -K /etc/chef/maplelabs123-validator.pem -o "recipe[${cookbook_name}@${app_version}]"
sudo chef-client -S "${central_chef_server_url}" -K /etc/chef/maplelabs123-validator.pem -o "recipe[petclinic_mysql_config]"
