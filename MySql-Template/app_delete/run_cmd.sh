. $(dirname $(readlink -f "variables.tf"))/values.sh
python chef_oper/remove_data_from_data_bag.py $chef_dir $chef_user_pem $project_name $sf_app_name
