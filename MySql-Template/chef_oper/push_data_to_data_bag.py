import os
import sys
import json
from subprocess import Popen, PIPE

# Read application parameters
chef_location = sys.argv[1]
secret_key_name = sys.argv[2]
project_name = sys.argv[3]
app_name = sys.argv[4]

input_param_list = sys.argv[5:]
input_param_dict = {input_param_list[index]: input_param_list[index + 1] for index in
                    range(0, len(input_param_list) - 1, 2)}

# Download the Chef data bags
# chef_install_dir = 'C:' + os.path.sep + 'Users' + os.path.sep + 'Arvind' + os.path.sep + 'Desktop' + os.path.sep + 'MCD-WorkStation' \
#                   + os.path.sep + 'chef-starter' + os.path.sep + 'chef-repo'
chef_install_dir = chef_location + os.path.sep + 'chef-repo'
secret_file_loc = chef_install_dir + os.path.sep + '.chef' + os.path.sep + secret_key_name
new_databag = False

os.chdir(chef_install_dir)
cmd = 'knife download data_bags'
print(os.getcwd())
os.system(cmd)

# Create chef data bag
data_bag_name = 'adobe_dbag'
data_bag_file_name = 'mcmp.json'
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
    new_databag = True
    with open(data_bag_file_path, 'w') as fh:
        app_dict = {}
        fh.write(json.dumps(app_dict))
    # data_bag_id = ''.join(random.choice(string.ascii_lowercase + string.digits) for _ in range(16))
    data_bag_id = 'mcmp'

data_bag_data = dict()

cmd = "knife data bag show " + data_bag_name + " " + data_bag_file_name.split('.')[
    0] + " --secret-file " + secret_file_loc + " -F json"
proc = Popen([cmd], stdout=PIPE, stderr=PIPE, shell=True)
stdout, stderr = proc.communicate()

if not new_databag:
    with open(data_bag_file_path, 'w') as fh:
        fh.write(stdout)

with open(data_bag_file_path, 'r') as fh:
    data_bag_data = json.load(fh)

    if project_name not in data_bag_data.keys():
        data_bag_data[project_name] = dict()

    if app_name not in data_bag_data.get(project_name).keys():
        data_bag_data[project_name][app_name] = dict()

    app_data_bag = data_bag_data.get(project_name).get(app_name)

    if data_bag_id:
        data_bag_data['id'] = data_bag_id

    for param_key, param_val in input_param_dict.iteritems():
        if param_key == "version":
            app_data_bag['version'] = param_val
            continue

        if param_key == "stage":
            app_data_bag['stage'] = param_val
            continue

        if not 'app_data' in app_data_bag.keys():
            app_data_bag['app_data'] = dict()

        app_data_bag['app_data'][param_key] = param_val

print("data: " + json.dumps(data_bag_data))
with open(data_bag_file_path, 'w') as fh:
    fh.write(json.dumps(data_bag_data))

cmd = "knife data bag from file " + data_bag_name + " " + data_bag_file_name + " --secret-file " + secret_file_loc
os.system(cmd)


