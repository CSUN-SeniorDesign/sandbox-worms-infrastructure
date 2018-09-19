+++
title = "How to Setup Terraform Infrastructure for Team SandboxWorms"
description = ""
weight = 80
# Type of content, set "slide" to display it fullscreen with reveal.js
type="page"
date = "9/15/2018 8:30:16 PM "
# Creator's Display name
creatordisplayname = "Aubrey Nigoza"
# Creator's Email
creatoremail = "aubrey.nigoza.34@my.csun.edu"
# LastModifier's Display name
lastmodifierdisplayname = ""
# LastModifier's Email
lastmodifieremail = ""
tags = ["aws", "vpc", "service infrastructure", "design"]
+++
## Goal: ##
Setup a consistent terraform environment across multiple team members of SandboxWorms.

## Workflow: ##
1. 



## Specs: ##



## Instructions ##

### Generate AWS KEY ###
1. Login to [https://429784283093.signin.aws.amazon.com/console](https://429784283093.signin.aws.amazon.com/console) ***Very Important Step. Please go to this specific url***
2. Username has been provided by John
3. Go to IAM
4. Click Users on the left-hand side
5. Click on your username
6. Click on Security Credentials
7. Click on Create access key
8. Save this access key as you will not be able to see the secret again. If lost, just generate a new one.

### Generate Credential Files ###
1. Create 2 files with the name:
	- credential.auto.tfvars
	- credential-backend.auto.tfvars
2. Edit credential.auto.tfvars

		aws_access_key = "*insert your access key here*"  
		aws_secret_key = "*insert your secret key here*"

3. Edit credential-backend.auto.tfvars

		access_key = "*insert your access key here*"  
		secret_key = "*insert your secret key here*"	

4. Copy these files to the following sub-folders in our terraform directory:
	- IAM
	- VPC
	- ServiceInfrastructure   

### Initialize your local working directory ###
*This process must be done on each sub-folders in our terraform directory because each sub-folders is a standalone terraform directory*  
1. Open a shell or cmd  
2. Go to the subdirectory that you are working on, ie: ServiceInfrastructure.
3. Initialize the directory. Initializing will download all the providers needed based on your code and will give you a chance to setup the remote backend. 

Here are the steps after opening shell or cmd

	cd c:\Repo\sandbox-worms-infrastructure\terraform\ServiceInfrastructure
	terraform init -backend-config=credential-backend.auto.tfvars -backend-config=backend.auto.tfvars
	

