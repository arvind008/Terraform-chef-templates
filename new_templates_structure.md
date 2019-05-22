# New template design 
#### Sample template structure
```bash
elasticsearch-cluster-3-node-aws/
├── ansible
│   ├── ansible.cfg
│   ├── playbook.yml
│   ├── roles
│   │   ├── ansible-elasticsearch
│   │   ├── bootstrap-os
│   │   └── configlocal
│   └── templates
│       └── basic.json
├── artifacts
│   ├── hosts.ini
│   ├── playbook.log
│   ├── externalURL.json
|   ├── all.yml
|   └── values.tfvars
├── keys
│   └── awskube.pem
├── logo.png
├── parameters.json
├── template_info.json
├── terraform
│   ├── inventory.tf
│   ├── main.tf
│   ├── outputs.tf
│   ├── templates
│   │   └── inventory.tpl
│   └── variables.tf
└── terraform.tfstate

```

- **ansible**\
All application creation logic, ansible roles, playbooks and ansible config files\
Also defines playbooks required for adding new node, upgrading application\
>Default playbook names:
>    - playbook.yml or cluster.yml - for creating application 
>    - add-node.yml - for adding new nodes, if not available the playbook.yml or cluster.yml will be used
>    - remove-node.yml - for reducing cluster size
>    - upgrade.yml - for upgrading app, if not available the playbook.yml or cluster.yml will be used
- **logo.png** - Application logo 
- **parameters.json** - Will contain user configurable parameters during application creation 
- **template_info.json** - Define basic template info
- **terrafrom** - Contain infrastructure creation code for the application
- **_artifacts_**
> Created during run-time\
> Contains output of create app operation, contains ansible logs, inventory files,\
> variables used during application creation for ansible and terraform
>
> _**Contents of artifacts directory will be available for download**_ 
- _terrraform.tfstate_ - Created during run-time, will contain output of terrafrom
- _keys_ - Created during run-time, will contain ssh keys required to run ansible

#### Commands
```bash
terraform init terraform/
terraform apply -auto-approve -var-file="artifacts/values.tfvars" terraform/
export ANSIBLE_CONFIG=./ansible/ansible.cfg
ansible-playbook -b -v -i artifacts/hosts.ini --user=ubuntu --key-file=./keys/awskube.pem ansible/playbook.yml
terraform destroy -auto-approve -var-file="artifacts/values.tfvars" terraform/
```