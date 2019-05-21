#!/usr/bin/env python
import os
import sys
import json


# Read application input parameters
project_name = sys.argv[1]
app_name = sys.argv[2]
deploy_stage = sys.argv[3]

input_param_list = sys.argv[4:]
input_param_dict = { input_param_list[index]: input_param_list[index+1] for index in range(0, len(input_param_list), 2)}
# Download the Chef data bags
# chef_install_dir = 'c:' + os.path.sep + 'Users' + os.path.sep + 'manal_g' + os.path.sep + 'Desktop' + os.path.sep + 'mcd' + os.path.sep + 'chef-repo'
chef_install_dir = os.path.sep + 'root' + os.path.sep + 'chef-repo'

os.chdir(chef_install_dir)
cmd = 'knife download data_bags'

# Create chef data bag
data_bag_name = 'adobe_dbag'
data_bag_file_name = 'adobe_dbag.json'
cmd = "knife data bag create " + data_bag_name
os.system(cmd)

data_bag_dir_path = os.getcwd() + os.path.sep + "data_bags" + os.path.sep + data_bag_name
data_bag_file_path = data_bag_dir_path + os.path.sep + data_bag_file_name
data_bag_id = None

# Create data bag directory if not exists
if not os.path.exists(data_bag_dir_path):
    os.mkdir(data_bag_dir_path)

# Create data bag file if file not exists
if not os.path.exists(data_bag_file_path):
    with open(data_bag_file_path, 'w') as fh:
        app_dict = {project_name: {app_name: {deploy_stage: {"version": "", "app_data": {}}}}}
        fh.write(json.dumps(app_dict))
    # data_bag_id = ''.join(random.choice(string.ascii_lowercase + string.digits) for _ in range(16))
    data_bag_id = 'mcmp'

data_bag_data, app_data_bag = dict(), dict()
with open(data_bag_file_path, 'r') as fh:
    data_bag_data = json.load(fh)
    print("---->", json.dumps(data_bag_data))
    if project_name not in data_bag_data.keys():
        data_bag_data[project_name] = dict()

    if app_name not in data_bag_data.get(project_name).keys():
        data_bag_data[project_name][app_name] = dict()

    if deploy_stage not in data_bag_data.get(project_name).get(app_name).keys():
        data_bag_data[project_name][app_name][deploy_stage] = dict()
        data_bag_data[project_name][app_name][deploy_stage]["version"] = str()
        data_bag_data[project_name][app_name][deploy_stage]["app_data"] = dict()

    app_data_bag = data_bag_data.get(project_name).get(app_name).get(deploy_stage)

if data_bag_id:
    data_bag_data['id'] = data_bag_id

for param_key, param_val in input_param_dict.iteritems():
    if param_key == 'version':
        app_data_bag['version'] = param_val
        app_data_bag['app_data'] = dict()
        continue
    else:
        if not 'app_data' in app_data_bag.keys():
            app_data_bag['app_data'] = dict()

        if '_node' in param_key:
            if param_key not in app_data_bag.get('app_data').keys():
                app_data_bag['app_data'][param_key] = list()
            app_data_bag['app_data'][param_key].append(param_val)
            continue

        app_data_bag['app_data'][param_key] = param_val

print("data: " + json.dumps(data_bag_data))
with open(data_bag_file_path, 'w') as fh:
    fh.write(json.dumps(data_bag_data))

cmd = "knife data bag from file " + data_bag_name + " " + data_bag_file_name
os.system(cmd)

