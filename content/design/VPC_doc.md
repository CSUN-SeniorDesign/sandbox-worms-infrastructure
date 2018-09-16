+++
title = "Virtual Private Cloud Setup"
description = "Provide design documentation of the Sandboxworms system"
weight = 3
# Type of content, set "slide" to display it fullscreen with reveal.js
type="page"
date = "2018-09-05"
# Creator's Display name
creatordisplayname = "John Vinuya"
# Creator's Email
creatoremail = "johnphilip.vinuya.778@my.csun.edu"
# LastModifier's Display name
lastmodifierdisplayname = " Aubrey Nigoza"
# LastModifier's Email
lastmodifieremail = "aubrey.nigoza.34@my.csun.edu"
tags = ["aws", "vpc", "network", "design"]
+++

----------
**Date:** 9/4/2018 8:53:22 PM  
**Author(s):** [John Vinuya](mailto:johnphilip.vinuya.778@my.csun.edu) , [Aubrey Nigoza](mailto:aubrey.nigoza.34@my.csun.edu)
**Reviewer(s):**  
**Approver(s):**  
**Revision Number:** 2   
**Status:**  

----------
***Executive Summary:***  
The Sandboxworms established Virtual Private Cloud is the shared computing resource/virtual networking environment used for the Sandboxworms organization. It is, by extension, used for any EC2 instances created by Sandboxworms members for various projects. For the purposes of Team SandboxWorms, VPC also relates to the terraform environment used to create and modify various AWS resources related to VPC.

***Goals:***  

- Create VPC using custom options or Wizard
- Create Other VPC related resources using terraform:
	- Internet Gateway
	- Subnets
	- Route Tables
	- Security Groups
	- Elastic IP
	- NAT instances

***Background:***  
The VPC is to have 3 public subnets with 1024 hosts per subnets and 3 private subnets with 4096 per subnet. Each subnet must also be in a different availability zone. Two route tables must be made, one for public subnets and one for private subnets as well as one Internet Gateway attached to the public subnet routing table.

***High-Level Design:***     
In setting up the VPC, Amazon Web Services GUI Console will be used to create it. Terraform will be used to create every other resources. 3 pairs of private and public subnets will be created. Each pair will be on its own availability zone. 

***Detailed Design:***  
*Team Members Workflow:*  
Before starting any EC2 instance, the VPC must be chosen during instance configuration, a default VPC is given to every AWS account, but a custom VPC will be made for the purposes of this project. Depending on whether or not there is an elastic IP address allocated, the IPv4 CIDR Block can be filled accordingly once the 'Create VPC' option is selected. Upon the creation of the VPC, subnets can now be allocated on the 'Subnets' tab. Subnets can be added accordingly with the dynamically allocated addresses box checked. To make certain subnets public or private, there must be two routing tables configured. One routing table must have both the Internet Gateway as well as the local address to communicate with the other subnets; this is for the public subnets. The other routing table must have only the local address, with no IGW as this is for the private subnets. Next, you link the public and private subnets to the according routing table and use an EC2 instance to test. 

*AWS Network Infrastructure*  
Production account will use Virginia Region. Refer to the [diagram](https://docs.sandboxworms.me/design/). 6 Subnets were created on their own availability zones. An AWS Internet Gateway has been setup to allow inbound and outbound access from and to the EC2 instance in the public subnets. 

***Alternatives Considered:***  


