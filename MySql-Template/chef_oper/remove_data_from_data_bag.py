import os
import sys
import json
from subprocess import Popen, PIPE

# Read application parameters
chef_location = sys.argv[1]
secret_key_name = sys.argv[2]
project_name = sys.argv[3]
app_name = sys.argv[4]


# Download the Chef data bags
#chef_install_dir = 'C:' + os.path.sep + 'Users' + os.path.sep + 'Arvind' + os.path.sep + 'Desktop' + os.path.sep + 'MCD-WorkStation' \
#                    + os.path.sep + 'chef-starter' + os.path.sep + 'chef-repo'
chef_install_dir = chef_location + os.path.sep + 'chef-repo'
secret_file_loc = chef_install_dir + os.path.sep + '.chef' + os.path.sep + secret_key_name

os.chdir(chef_install_dir)
cmd = 'knife download data_bags'
print(os.getcwd())
os.system(cmd)

# data bag details
data_bag_name = 'adobe_dbag'
data_bag_file_name = 'mcmp.json'
data_bag_dir_path = os.getcwd() + os.path.sep + "data_bags" + os.path.sep + data_bag_name
data_bag_file_path = data_bag_dir_path + os.path.sep + data_bag_file_name

if not os.path.exists(data_bag_dir_path):
    print("No data bag " + data_bag_name + " remove")

if not os.path.exists(data_bag_file_path):
    print("No data bag " + data_bag_file_name + " remove")

cmd = "knife data bag show "+ data_bag_name + " " + data_bag_file_name.split('.')[0] + " --secret-file " + secret_file_loc + " -F json"
proc = Popen([cmd], stdout=PIPE, stderr=PIPE, shell=True)
stdout, stderr = proc.communicate()

with open(data_bag_file_path, 'w') as fh:
    fh.write(stdout)

with open(data_bag_file_path, 'r') as fh:
    data_bag_data = json.load(fh)

    if project_name not in data_bag_data.keys():
        print("No Project - " + project_name + " to remove")

    if app_name not in data_bag_data.get(project_name).keys():
        print("No Application - " + app_name + " to remove")

    del data_bag_data[project_name][app_name]

print("data: " + json.dumps(data_bag_data))
with open(data_bag_file_path, 'w') as fh:
    fh.write(json.dumps(data_bag_data))

cmd = "knife data bag from file " + data_bag_name + " " + data_bag_file_name + " --secret-file " + secret_file_loc + " -F json"
os.system(cmd)


