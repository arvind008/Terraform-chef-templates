import os
import yaml
import json
import subprocess

class ChefMysqlPush:
    """
    Python script to push the username and password fofr mysql in the data bag
    """

    def __init__(self):
        self.chef_dir = "/root/chef-repo/"
        self.data_bag_name = "mysql"
        self.data_bag_item = "mysql_details"

    def getData(self):
        with open("values.yaml", 'r') as fh:
            data = yaml.load(fh)
            self.mysql_username = data['MYSQL_UN']
            print(self.mysql_username)
            self.mysql_password = data['MYSQL_PWD']
            print(self.mysql_password)

    def pushData(self):
        os.chdir(self.chef_dir)

        data = {
            "id": self.data_bag_item,
            "mysql_username": self.mysql_username,
            "mysql_password": self.mysql_password
        }
        with open(self.data_bag_item+".json", "w") as fh:
            json.dump(data, fh)
            print(data)

        cmd = "knife data bag create " + self.data_bag_name
        print(cmd)
        proc = subprocess.Popen([cmd], stdout=subprocess.PIPE,
                                shell=True)
        proc.communicate()

        cmd = "knife data bag from file " + self.data_bag_name + ' ' + self.data_bag_item + '.json'
        print(cmd)
        proc = subprocess.Popen([cmd], stdout=subprocess.PIPE,
                                shell=True)
        proc.communicate()


if __name__ == "__main__":
    chefMysqlPush_obj = ChefMysqlPush()
    chefMysqlPush_obj.getData()
    chefMysqlPush_obj.pushData()
