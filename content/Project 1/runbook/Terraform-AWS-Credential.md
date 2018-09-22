+++
title = "How to Store AWS IAM Access Key"
description = ""
weight = 10
# Type of content, set "slide" to display it fullscreen with reveal.js
type="page"
date = "2018-09-10"
# Creator's Display name
creatordisplayname = "Aubrey Nigoza"
# Creator's Email
creatoremail = "aubrey.nigoza.34@my.csun.edu"
# LastModifier's Display name
lastmodifierdisplayname = ""
# LastModifier's Email
lastmodifieremail = ""
tags = ["aws", "vpc", "network", "design"]
+++
# **Create New User In EC2 Instance** #

## Goal: ##
Securely save and specify AWS Access Keys on terraform config 

## Workflow: Login ##
1. Create a file called terraform.tfvars 


## Specs: ##
1. Prevent AWS Access Key and Secret Key from being accessible on Github 
2. Allow .tf file to be ran by different credential without modification


## Instructions ##

1. Add terraform.tfvars on .gitignore  (one time only)
2. Add to one of the .tf files  (one time only)


		provider "aws" {   
		access_key = "${var.aws_access_key}"   
		secret_key = "${var.aws_secret_key}" 
		region = "${var.region}" 
		}
		variable "aws_access_key" {}
		variable "aws_secret_key" {}
		variable "region" {
        default = "us-east-1"
		}

3. Create terraform.tfvars


		aws_access_key = "put access key of IAM user"  
		aws_secret_key = "put secret key associated with access key"  





