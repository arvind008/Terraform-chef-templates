# Creating a new template 
## Directory structure
```
|--sample_template/
   |--ansible/
      |--roles/
         |--role1
         |--role2
      |--playbook.yml
   |--keys/
      |--samplekey.pem
   |--main.tf
   |--variables.tf
   |--parameters.json
   |--template_info.json
   |--user.txt
   |--values.tfvars
```
- main.tf - contains main infrastructure code
- variables.tf - contains all variables used in main.tf
- output.tf(optional)
- user.txt - user name to be used while accesing provisioned vms
- values.tfvars - created during execution, contains values of the variables defined in variables.tf
- hosts - ansible inventory file created after terraform execution completes
- keys(directory) - contains ssh private key used to run ansible 
- template_info.json - contains template description, name, app
```json
{
  "name": "sample template",
  "type": "terraform or cloudformation",
  "target_cloud": "aws or vcenter",
  "description": "template description",
  "prerequisites": "template prerequisites",
  "limitations": "template limitations"
}
```
- parameters.json - defines all parameters to be exposed in UI for customization during provisioning template
```json
[
  {
    "label": "Node Count",
    "fieldName": "node_count",
    "dataType": "integer",
    "min": 4,
    "max": 10,
    "defaultValue": 5,
    "placeholder": "number of nodes to create for data",
    "tooltip": "number of nodes to create for data"
  },
  {
    "label": "User Name",
    "fieldName": "username",
    "dataType": "string",
    "defaultValue": "root",
    "placeholder": "username to be used for authentication",
    "tooltip": "username to be used for authentication",
    "hidden": true
  },
  {
    "label": "Password",
    "fieldName": "password",
    "dataType": "password",
    "defaultValue": "DeepInsight@123",
    "placeholder": "Password to be used for authentication",
    "tooltip": "Password to be used for authentication",
    "hidden": true
  },
  {
    "label": "Instance Type",
    "fieldName": "instance_type",
    "dataType": "list",
    "multiselect": true,
    "options": [
      {
        "label": "Small",
        "value": "t2.small"
      },
      {
        "label": "Medium",
        "value": "t2.medium"
      }
    ],
    "defaultValue": "t2.small",
    "tooltip": "aws instance type for all nodes"
  }
]
```


## Note 
- Invoke ansible through terraform for examples refer elasticsearch template

