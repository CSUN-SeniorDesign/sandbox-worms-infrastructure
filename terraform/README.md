# Terraform Source Codes #
Sandbox Worms repository for terraform source codes

----------


### Team websites: ###
**Documentations:** https://docs.sandboxworms.me  
**Blog website:** https://blog.sandboxworms.me  
** System Diagram:** https://docs.sandboxworms.me/design/
----------

### Deliverables ###



- [ ] List of Tasks


### Quick Start ###
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


\#third round
rename backend.tf to backend.tf1
terraform init
terraform apply
rename backend.tf1 to backend.tf
terraform init -backend-config=credential-backend.auto.tfvars -backend-config=backend.auto.tfvars



Useful URLS:
https://www.terraform.io/docs/providers/aws/r/route_table.html

terraform graph | dot -Tpng > graph.png

https://www.terraform.io/docs/providers/aws/r/route_table.html#egress_only_gateway_id