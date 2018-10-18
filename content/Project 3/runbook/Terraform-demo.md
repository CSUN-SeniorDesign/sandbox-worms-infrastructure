+++
title = "How to Build AWS Infrastructure using Terraform"
description = ""
weight = 3
# 
type="page"
date = "2018-09-22"
# Creator's Display name
creatordisplayname = "Aubrey Nigoza"
# Creator's Email
creatoremail = "aubrey.nigoza.34@my.csun.edu"
# LastModifier's Display name 
lastmodifierdisplayname = "Aubrey Nigoza"
# LastModifier's Email
lastmodifieremail = "aubrey.nigoza.34@my.csun.edu"
tags = ["aws", "vpc", "terraform", "aws"]
+++
##Shows how to completely build our AWS Infrastructure from scratch##
Guide for presentation demo

### Assumptions ###
1. You have followed Terraform-Setup.md
### Instructions ###
1. Go to the terraform folder
2. Destroy existing environment, order of destroying is important
3. Recreate environment, order of creation is important

		cd ~/repo/sandbox-worms-infrastructure
		#Destroy
		cd ServiceInfrastructure
		terraform destroy
		cd ../VPC
		terraform destroy
		cd ../IAM
		terraform destroy
		#Now to recreate
		terraform apply -auto-approve
		cd ../VPC
		terraform apply -auto-approve
		cd ../ServiceInfrastructure
		terraform apply -auto-approve
		#Get some coffee. Drink for 6 minutes. AWS setup should be done
			




