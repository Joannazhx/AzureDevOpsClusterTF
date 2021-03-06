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
                    └──────── acr 
                             ├── main.tf  
                             ├── variables.tf 
                             └── output.tf 
              ├── pre     # create Azure storage to store state in remote backend 
                   ├── remote-storage.tf  
                   ├── variables.tf 
                   └── terraform.tfstate 
              ├── cluster     # create Aks, Acr, Resource Group for cluster env 
                   ├── main.tf  
                   ├── variables.tf 
                   └── terraform.tfvars 
     ├────── k8s         # simple service k8s deployment scripts 
     		       ├── postgresdb     # postgresDB contianer k8s deployment scripts
                   ├── configmap.yaml
                   ├── persistvoloumn.yaml
                   ├── deployment.yaml
                   └── service.yaml
              ├── app     # servian App contianer k8s deployment scripts
                   ├── configmap.yaml
                   ├── deployment.yaml
                   └── service.yaml
     ├────── pipelines   # Azure pipeline to auto init, validate, plan, apply terraform ; build & push docker image ; conatiner deploy to cluster
              ├── job  
                   ├── terraformApply.yaml
                   └── kuberneteApply.yaml
              ├── step  
                   ├── terraformTask.yaml
              ├── continuousDeployment.yaml
```
# Tools Install
1. AzureCLi
2. Terraform

# Terraform Section
## 1. Prepare Step
the /terraform/pre is to create Azure storage account associated with a resource group to store ftstate as cluster terraform backend
![image info](k8s-app/pics/storage_account.png)

in this folder, the ftstate is a shared file. Any resource changes should apply it locally and update ftstate file merge to master
```
cd {local_repo_path}/terraform/pre/
terraform init
terraform plan
# if there are any changes in plan
terraform apply
git add terraform.tfstate
git commit -m "update storage account ftstate"
git push origin {you-branch}
# make a PR to master
```

## 2. Create Azure Cluster Step
/terraform/cluster is to create a auto scaling node pool(1 -3) cluster in Azure associated with a resource group
![image info](k8s-app/pics/k8s_resource.png)
![image info](k8s-app/pics/acr.png)
```
cd {local_repo_path}/terraform/cluster/
terraform init
terraform validate
terraform plan -out tfplan
terraform show -json tfplan >> tfplan.json
terraform apply
```
# docker image build and push to acr
git repo : https://github.com/Joannazhx/TechChallengeApp
changed the net.Listen("tcp", ":{port}") for conatiner localhost 
fork from servian https://github.com/servian/TechChallengeApp
```
az acr login -n servainacr 
docker build . -t servainacr.azurecr.io/techchallengeapp:latest
docker push servainacr.azurecr.io/techchallengeapp:latest
```
# Kubernetes service deploy
k8s/postgresdb, one postgresdb run in one container in one pod and connect with k8s loadbalance type servie for access out cluster, persist voloumn mounted for data storage in pod, env vars use configmap mount to container in pod
k8s/app, servian webapp run in one container in one pod and connect with k8s loadbalance type servie for access out cluster, conf.toml use configmap to mount to conatianer in pod
```
cd {local_repo_path}/k8s
az aks get-credentials --resource-group servain-aks-rg-dev  --name servain-aks-dev --overwrite
# first postgres
kubectl apply -f postgresdb/configmap.yaml
kubectl apply -f postgresdb/persistvoloumn.yaml
kubectl apply -f postgresdb/deployment.yaml
kubectl apply -f postgresdb/service.yaml
# check the postgres pod & servie
kubectl describe pod {}
kubectl exec -it {postgres-pod-name}  -- psql -U postgres
PGPASSWORD=123 psql -h {postgres-service-ip}  -p 5432 -d app -U postgres
# servian webapp
kubectl apply -f app/configmap.yaml
kubectl apply -f app/deployment.yaml
kubectl apply -f app/service.yaml
# check webapp deployment
kubectl describe pod {webapp-pod-name}
```
after deployment verify
```
kubectl get pods -o wide
kubectl get servic -n default
kubectl describe svc {postgres/webapp}
```
postgress pod
![image info](k8s-app/pics/postgres_pod.png)
webapp pod
![image info](k8s-app/pics/webapp_pod_1.png)
![image info](k8s-app/pics/webapp_pod_2.png)
k8s servies
![image info](k8s-app/pics/pod_service.png)
http://20.84.192.206:3000
![image info](k8s-app/pics/webapp.png)
# Azure Pipeline
## set ups
1. Create service connections
 - Azure resource manage name 'Azure Service Manage'

  <img src="k8s-app/pics/service_connection.png" width="800">
 - Docker Registry name 'Azure Container Register'

  <img src="k8s-app/pics/acr_service_connection.png" width="800">
 - Kubernetes name 'Azure Kubernetes Cluster'
 
  <img src="k8s-app/pics/aks_service_connection.png" width="800">
2. create a pipeline with path: k8s-app/pipeline/continuousDeployment.yaml
## yaml templates
   - entry: [k8s-app/pipeline/deployment.yaml](k8s-app/pipeline/continuousDeployment.yaml) 
   - jobs template:
      [k8s-app/pipeline/job/terraformApply.yaml](k8s-app/pipeline/job/terraformApply.yaml)
      [k8s-app/pipeline/job/kuberneteApply.yaml](k8s-app/pipeline/job/kuberneteApply.yaml)
   - task template: [k8s-app/pipeline/step/terraformTask.yaml](k8s-app/pipeline/step/terraformTask.yaml)
  
## pipeline stages
### brief
 2 stages in terraform deploy pipeline
  - Check Prepare Terraform
  - Apply cluster Terraform
  - Build & Publish App Docker image
  - Apply k8s scripts(deploy conatiners to k8s cluster)
 
<img src="k8s-app/pics/stages.png" width="600">

### 1. Prepare check stage
workdir: terraform/pre/
  - checkout repo
  -  install terraform in cloud agent 
  -  tf init 
  - tf validate
  - tf plan 
  -  publish .tfplan 
  -  if resource change error ( apply local and udpate tfstate to master)
  
  <img src="k8s-app/pics/prepare_stage.png" width="300">
  
### 2. Cluster Apply stage
 workdir: terraform/cluster/
 - checkout repo
 - install terraform in cloud agent 
 - tf init 
 - tf validate
 - tf plan 
 - publish .tfplan 
 - tf plan 

<img src="k8s-app/pics/cluster_stage.png" width="300">

### 3. Build & Publish App Docker Image
 checkout another repo : https://github.com/Joannazhx/TechChallengeApp
 - checkout App repo
 - Login to ACR
 - Build App Docker Image 
 - Push App image to acr

<img src="k8s-app/pics/docker_stage.png" width="300">

### 4. Deploy To Kubenetes Cluster
 2 jobs : Deploy postgres & Deploy App
 
 <img src="k8s-app/pics/k8s_stage_jobs.png" width="300">
 
 - checkout repo
 - Kubectl Installer
 - Kubectl Apply each file 
 - logout az cluster

 <img src="k8s-app/pics/k8s_db.png" width="300">



