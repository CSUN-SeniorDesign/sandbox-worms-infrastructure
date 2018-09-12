Doc

terraform init
terraform apply -var-file=backend.tfvars 
terraform init -backend-config=credential-backend.auto.tfvars
terraform plan -var-file=backend.tfvars

second round
terraform init
terraform apply
terraform init -backend-config=credential-backend.auto.tfvars -backend-config="../module/backend.tf" #didnt work
terraform init -backend-config=credential-backend.auto.tfvars -backend-config=backend.auto.tfvars
terraform plan

\#this worked for initial setup


\#john on laptop
terraform init -backend-config=credential-backend.auto.tfvars -backend-config=backend.auto.tfvars