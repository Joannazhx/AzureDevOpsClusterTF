# Repository structure
```
 k8s-app 
    ├── terraform        # terraform directory for create Azure resources
             ├── module  # terraform modelues
                   ├── resource_groups
                             ├── main.tf  
                             ├── variables.tf 
                             └── output.tf      
                   ├── storage_account
                             ├── main.tf  
                             ├── variables.tf 
                             └── output.tf      
                   └──────── aks 
                             ├── main.tf  
                             ├── variables.tf 
                             └── output.tf      
              ├── pre     # create Azure storage to store state in remote backend 
                   ├── remote-storage.tf  
                   ├── variables.tf 
                   └── terraform.tfstate 
              ├── cluster     # create Aks cluster 
                   ├── main.tf  
                   ├── variables.tf 
                   └── terraform.tfstate  
     ├────── k8s         # simple service k8s deployment scripts 
              ├── deployment.yaml
              ├── service.yaml
     ├────── pipelines   # Azure pipeline to auto init, validate, plan, apply terraform 
              ├── job  
                   ├── terraformApply.yaml
              ├── step  
                   ├── terraformTask.yaml
              ├── deployment.yaml
              
```
