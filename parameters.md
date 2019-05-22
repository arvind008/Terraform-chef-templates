### parameters.josn file syntax

#### basic structure
```json
{
  "customTypes": {
    "instanceType": {
      "parameters": [
        {
          "label": "Node Type",
          "fieldName": "node_type",
          "dataType": "list",
          "defaultValue": "t2.medium",
          "options": [
            {
              "label": "Large",
              "value": "t2.large"
            },
            {
              "label": "Custom",
              "value": "custom"
            }
          ]
        },
        {
          "label": "Number of vCPU",
          "tooltip": "number of vcpu's",
          "placeholder": "number of vcpu's",
          "dataType": "integer",
          "fieldName": "vcpus",
          "defaultValue": 2,
          "min": 1,
          "max": 8
        },
        {
          "label": "RAM(GB)",
          "tooltip": "Memory size in GB",
          "placeholder": "Memory size in GB",
          "dataType": "integer",
          "fieldName": "ram",
          "defaultValue": 8,
          "min": 4,
          "max": 16
        }
      ],
      "action": {
        "label": "Discover",
        "url": "https://www.snappyflow.io/snappyflow/snappyflowapp/sizing"
      }
    }
  },
  "parameters": [
    {
      "label": "ElasticSearch Nodes Details",
      "description": "",
      "dataType": "group",
      "parameters": [
        {
          "label": "Node Count",
          "tooltip": "Number of data Nodes",
          "placeholder": "Number of data Nodes",
          "dataType": "integer",
          "fieldName": "nodecount",
          "defaultValue": 2,
          "min": 2,
          "max": 7
        },
        {
          "label": "Instance Type",
          "tooltip": "aws instance type for all nodes",
          "dataType": "instanceType",
          "fieldName": "node_instance_type"
        },
        {
          "label": "Disk Size(GB)",
          "tooltip": "Disk size in GB",
          "placeholder": "Disk size in GB",
          "dataType": "integer",
          "fieldName": "node_disk_size",
          "defaultValue": 10,
          "min": 10,
          "max": 200
        },
        {
          "label": "Disk Type",
          "tooltip": "Node Disk Type",
          "placeholder": "Node Disk Type",
          "dataType": "list",
          "fieldName": "node_disk_type",
          "defaultValue": "standard",
          "options": [
            {
              "label": "EBS Magnetic",
              "value": "standard"
            },
            {
              "label": "General Purpose SSD",
              "value": "gp2"
            }
          ]
        }
      ]
    },
    {
      "label": "ElasticSearch Master Details",
      "description": "",
      "dataType": "group",
      "parameters": [
        {
          "label": "Instance Type",
          "tooltip": "aws instance type for master node",
          "dataType": "instanceType",
          "fieldName": "master_instance_type"
        },
        {
          "label": "Disk Size(GB)",
          "tooltip": "Disk size in GB",
          "placeholder": "Disk size in GB",
          "dataType": "integer",
          "fieldName": "master_disk_size",
          "defaultValue": 10,
          "min": 10,
          "max": 200
        },
        {
          "label": "Disk Type",
          "tooltip": "Master Disk Type",
          "placeholder": "Node Disk Type",
          "dataType": "list",
          "fieldName": "master_disk_type",
          "defaultValue": "standard",
          "options": [
            {
              "label": "EBS Magnetic",
              "value": "standard"
            },
            {
              "label": "General Purpose SSD",
              "value": "gp2"
            }
          ]
        }
      ]
    }
  ]
}

```

#### common keys
- tooltip 
- placeholder
- edit - true or false, indicates if parameter can be edited once provision is completed\
if edit is true then allow value to be edit once provision is complted
if edit is false or not defined for a paramater donot allow value to be edited once provision is completed
- mandatory - true or false, if true then this value is required, if key is not defined then considered as false
- label - display name of paramater
- defaultValue - default value of the variable if any 
- dataType - supported data types are integer,list,string,password and one of the customTypes
- fieldName - actual variable name used in the template prefixed with ansible_ or tf_ to differentiate them as ansible or terrafrom variables
> if variable name starts with tf_ then considered as terraform variable\
> if varaible name starts with ansible_ then considered as asnible variable\
> variable not starting with ansible_ of tf_ will be ignored


> all variable starting with tf_ will be written to values.tfvars to use with terraform\
> all variables starting with ansible_ will be written to all.yml file\
> **_tf\_ and ansible\_ will be discarded from variable names when they are written to files_**

#### data types description 

##### string type
```json
{
  "label": "Cluster Name",
  "fieldName": "aws_cluster_name",
  "tooltip": "Cluster name should be unique",
  "placeholder": "Unique name for cluster",
  "mandatory": true,
  "dataType": "string"
}
```
##### integer type
```json
{
  "label": "Number of Master Nodes",
  "tooltip": "Number of Master Nodes",
  "placeholder": "Number of Master Nodes",
  "dataType": "integer",
  "fieldName": "aws_kube_master_num",
  "defaultValue": 1,
  "min": 1,
  "max": 3
}
```
- can contain min and max field to limit values

##### list type
```json
{
  "label": "Disk Type",
  "tooltip": "Broker Disk Type",
  "placeholder": "Broker Disk Type",
  "dataType": "list",
  "fieldName": "master_disk_type",
  "defaultValue": "standard",
  "multiselect": false,
  "options": [
    {
      "label": "EBS Magnetic",
      "value": "standard"
    },
    {
      "label": "General Purpose SSD",
      "value": "gp2"
    }
  ]
}
```
- used to display dropdown list with single or multiselect values can also be used to display check box
- if multiselect key is defined and value is true then this allows multiple values to be selected from list,\
if multislelect is false only one of the values can be slected from the list, \
if key is not defined multiselect is assumed to be false 

#### passowrd type
```json
{
  "label": "User Password",
  "tooltip": "User Password",
  "dataType": "password",
  "fieldName": "ambari_pass",
  "defaultValue": "admin"
}
```
- valued entered to this field will be hidden

#### group type (Grouped parameters)
```json
{
  "label": "Master Node Details",
  "dataType": "group",
  "description": "",
  "parameters": [
    {
      "label": "Number of Master Nodes",
      "tooltip": "Number of Master Nodes",
      "placeholder": "Number of Master Nodes",
      "dataType": "integer",
      "fieldName": "aws_kube_master_num",
      "defaultValue": 1,
      "min": 1,
      "max": 3
    },
    {
      "label": "Instance Type",
      "tooltip": "aws instance type of all master nodes",
      "dataType": "instanceType",
      "fieldName": "aws_kube_master_size"
    },
    {
      "label": "Disk Size(GB)",
      "tooltip": "Disk size in GB",
      "placeholder": "Disk size in GB",
      "dataType": "integer",
      "fieldName": "master_disk_size",
      "defaultValue": 40,
      "min": 10,
      "max": 200
    },
    {
      "label": "Disk Type",
      "tooltip": "Broker Disk Type",
      "placeholder": "Broker Disk Type",
      "dataType": "list",
      "fieldName": "master_disk_type",
      "defaultValue": "standard",
      "options": [
        {
          "label": "EBS Magnetic",
          "value": "standard"
        },
        {
          "label": "General Purpose SSD",
          "value": "gp2"
        }
      ]
    }
  ]
}
```
- common parameters of the infrastructure can be grouped for easier configuration through UI 

#### customTypes
```json
{
    "instanceType": {
      "parameters": [
        {
          "label": "Node Type",
          "fieldName": "node_type",
          "dataType": "list",
          "defaultValue": "t2.2xlarge",
          "options": [
            {
              "label": "Medium",
              "value": "t2.large"
            },
            {
              "label": "Large",
              "value": "t2.2xlarge"
            },
            {
              "label": "Custom",
              "value": "custom"
            }
          ]
        },
        {
          "label": "vCPU",
          "tooltip": "Number of vcpu's",
          "placeholder": "number of vcpu's",
          "dataType": "integer",
          "fieldName": "vcpus",
          "defaultValue": 2,
          "min": 1,
          "max": 8
        },
        {
          "label": "RAM(GB)",
          "tooltip": "Memory size in GB",
          "placeholder": "Memory size in GB",
          "dataType": "integer",
          "fieldName": "ram",
          "defaultValue": 2,
          "min": 1,
          "max": 32
        }
      ],
      "action": {
        "label": "Discover",
        "url": "https://www.snappyflow.io/snappyflow/snappyflowapp/sizing"
      }
    }
}
```
- Custom types are combination of string,list and integer 
- Can also include action block on to which can be used to implement custom logic
- parameter fieldName should not include tf_ and ansible_ in their names inside customTypes

