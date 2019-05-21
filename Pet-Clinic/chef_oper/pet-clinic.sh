. $(dirname $(readlink -f "variables.tf"))/values.sh
python chef_oper/push_data_to_data_bag.py $chef_dir $chef_user_pem $project_name $sf_app_name stage $1 version $2
