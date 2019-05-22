## basic template_info

```json
{
  "name": "Elasticsearch Cluster",
  "type": "terraform",
  "app": "elasticsearch",
  "target_cloud": "aws",
  "description": "OS: Ubuntu 16.04  Master Nodes: 1",
  "prerequisites": "",
  "limitations": "",
  "logo": null,
  "dashboard_template": "ES Application"
}
```

- name - name of the template 
- type - terrafrom or cloudformation
- app - app type ex: kubernetes, kafka, elasticsearch
- target_cloud - aws, gcp, vsphere
- description - brief description of template
- prerequisites - pre-requisites if any before provisioning this template 
- limitations - template limitations if any 
- logo - logo displayed for template, value can be null or a url if value is null template directory is searched for logo.png
- dashboard_template - SF dashboard template that can be used for visualiztion

