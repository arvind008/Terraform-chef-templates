#!/bin/bash
sudo apt -y update
sudo apt install -y awscli
sudo mkdir -p /etc/chef
sudo curl -LO https://www.chef.io/chef/install.sh
sudo bash install.sh
#sudo aws s3 cp s3://hubvpc/chef-keys/"${chef_user_pem}" /etc/chef/gmanal.pem
sudo aws s3 cp s3://hubvpc/chef-keys/"${chef_organization_pem}" /etc/chef/${chef_organization_pem}
sudo aws s3 cp "${s3_build_jar}"/spring-petclinic-"${app_version}".jar /home/ubuntu/spring-petclinic-"${app_version}".jar
sudo knife ssl fetch -s "${central_chef_server_url}"
sudo echo "log_level       :info
log_location     STDOUT
chef_server_url '${central_chef_server_url}'
trusted_certs_dir '/root/.chef/trusted_certs'
ssl_verify_mode  :verify_none" >> /etc/chef/client.rb
sudo echo "mysql_app_name=${mysql_app_name}
project_name=${project_name}
sf_app_name=${sf_app_name}
pipeline_stage=${pipeline_stage}
chef_secret_key_loc=/etc/chef/${chef_user_pem}" >> /etc/petclinic.config
sudo chef-client -S "${central_chef_server_url}" -K /etc/chef/${chef_organization_pem} -o "recipe[java]"
sudo chef-client -S "${central_chef_server_url}" -K /etc/chef/${chef_organization_pem} -o "recipe[mysqld]"
sudo chef-client -S "${central_chef_server_url}" -K /etc/chef/${chef_organization_pem} -o "recipe[${cookbook_name}]"


