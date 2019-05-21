import os
import sys
import subprocess
import json


class ChefClientReports:

    def __init__(self, **kwargs):
        self.dns_host_file = kwargs.get('dns_file')
        self.chef_log_location = kwargs.get('chef_log_location')

        self.chef_dir = os.path.sep + "root" + os.path.sep + "chef-repo"
        self.chef_client_dns_names = list()
        self.node_run_id = dict()

    def check_report_exists(self):
        # command to move to the chef-rep directory
        os.chdir(self.chef_dir)

        # command to run knide runs list
        for private_dns in self.chef_client_dns_names:
            cmd = "knife runs list " + private_dns + ' -F json'
            print("command: " + cmd)
            proc = subprocess.Popen([cmd],stdout=subprocess.PIPE, stderr=subprocess.PIPE, shell=True)
            stdout, stderr = proc.communicate()

            if stdout.strip():
                print("stdout: \n" + stdout)
                dns_dict = json.loads(stdout)
                for entry in dns_dict.iteritems():
                    if entry['node_name'] == private_dns:
                        if os.path.exists(self.chef_log_location + os.path.sep + 'application.log'):
                            os.remove(self.chef_log_location + os.path.sep + 'application.log')

                        with open(self.chef_log_location + os.path.sep + 'application.log','a+') as fh:
                            cmd = "knife runs show " + entry['run_id'] + ' -F json'
                            proc = subprocess.Popen([cmd], stdout=subprocess.PIPE, stderr=subprocess.PIPE, shell=True)
                            stdout, stderr = proc.communicate()
                            fh.write(stdout)
                    if private_dns in self.node_run_id.keys():
                        run_id = entry['run_id']
                        self.node_run_id[private_dns].append(run_id)
                    else:
                        if private_dns == entry['node_name']:
                            run_id = entry['run_id']
                            self.node_run_id[private_dns] = [run_id]
                    print(self.node_run_id)
                    print("Successfully executed chef recipes for node - " + private_dns)
                    continue
            else:
                # print("stderr: \n" + stderr)
                print("Failed to execute chef recipes for node - " + private_dns)
                sys.exit(1)
        sys.exit(0)

    def read_dns(self, dns_type="private"):
        with open(self.dns_host_file) as dns_host_file:
            for dns_entry in dns_host_file.readlines():
                public_dns, private_dns = dns_entry.split(" ")
                if dns_type == "private":
                    self.chef_client_dns_names.append(private_dns.split("=")[-1].strip())
                else:
                    self.chef_client_dns_names.append(public_dns.split("=")[-1].strip())


if __name__ == "__main__":
    dns_file = sys.argv[1]
    chef_log_location = sys.argv[2]
    chef_report_obj = ChefClientReports(dns_file=dns_file, chef_log_location=chef_log_location)
    chef_report_obj.read_dns()
    chef_report_obj.check_report_exists()



