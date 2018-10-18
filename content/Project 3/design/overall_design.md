+++
title = "System Design"
description = "Provide design documentation of the Sandboxworms system"
weight = 1
# Type of content, set "slide" to display it fullscreen with reveal.js
type="page"
date = "2018-09-03"
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

----------
**Date:** 9/4/2018 8:53:22 PM  
**Author(s):** [Aubrey Nigoza](mailto:aubrey.nigoza.34@my.csun.edu)  
**Reviewer(s):**  
**Approver(s):**  
**Revision Number:** 3  
**Status:**  
PROJECT 2
----------
***Executive Summary:***  

Sandboxworms system provides the team members a platform to learn, experiment and practice on multiple technology. It includes, but not limited to CircleCI, Packer, Terraform, Ansible, Github, Hugo, Markdown files, Linux Servers, AWS services (EC2, VPC, IGW, Subnets, Route53 etc.), DNS, and Certificates. With the platform in place, team members will be able to apply the theories and principles learned from all the previous CSUN courses. The system will also provide the team members a platfrom to post blogs of their experiences for the week.    

***Goals:***  

- Automation of AWS Infrastructure creation and modification
- Automation of Service Instances configuration
- Improvement in blog posting workflow
- Team-wide consistent setup of different tools and environments (Terraform and Ansible)
- Automated deployment of website just by pushing the source code to the gihub repository.


***Non-goals:***  

- High-Availability by utilizing multiple availability zones


***Background:*** 
 
The system is being designed by CSUN students who have very limited experience in most of the technology being used. Therefore, constant downtime during the project deployment as team members collaborate is to be expected. It should also be noted that although the implementation is small, many of the design choices will be made in consideration of possible future growth and potential real-life use. 

We will refer to Amazon Web Services as AWS. Production account will be referred to the AWS account that will be submitted to the professor for grading.


***High-Level Design:***     
Although this projects do not use previous implementations from Project 0, it does utilize the knowledge and insight gained from the experience on setting up the AWS infrastructure. We will be using terraform and ansible as our primary tools in completing Project 1. 

Terraform will be used to setup the environment in AWS. Ansible will be used to configure the service infrastructures and deploy new blog post every week. In building up the environment, the goal is to promote portability of the code and avoid static or manual input for the environment to be setup. If manual input is needed, it must be on a separate file to increase visibility.


## Detailed Design:  ##
***Team Members Workflow:***  
Each team member will setup a the repository locally. A pull request will need to be submitted for any change. At least 1 team member will need to do a peer review of the change and approve the merge. Application of terraform codes can and should be done at each member's prerogative. This will help in learning the platforms, terraform and ansible.

***AWS Infrastructure***
- Please refer to the diagrams for visual aid
- A pair of subnet, private and public, will be placed in one Availability Zone. The other pairs of subnets should be configured on an used availability zones.
- Application Load Balancers on two public subnets. Two listeners - port 80 and port 443. Port 80 will redirect to port 443.
- 2 Red Hat Linux Server that will server as webserver should be place in Private subnet
- Bastion Host should be placed in public subnet
- EC2 Nat Instance should be placed in public subnet 

***Terraform:*** 

- All terraform codes must be placed in the terraform subfolder of the Infrastructure Repository.
- AWS environment built by terraform must be able to be rebuilt at anytime without hard-coding information that is created on each build. For example, the ip address of the Elastic IP, EC2 instances, ALB, etc.
- Variables and Data should be used as much as possible.
- The main terraform folder contains the code for building the Remote State Infrastructure
- The 3 subfolders in terraform will be IAM, VPC and ServiceInfrastructure.
- IAM subfolder or environment will contain the codes for building: 
	- IAM users
	- Groups
	- Group attachments
	- Keypair import
- VPC subfolder 
	- Availability Zones
	- Subnets
	- EC2 NAT Instance
	- Route tables
	- Security groups
- Service Infrastructure subfolder or environment will contain the codes for building:
	- Application Load Balancer
	- EC2 instances for Bastion and Webservers
	- Route 53
	
    

***EC2 WebServer Instance***  
**OS:** Redhat Linux 7  
**Services/Daemon/Modules Installed:** httpd
**Firewall Ports:** 22, 80  
**File Security Implemented:** File Permission, ACL  
**Apache Configuration:** NamedVirtualHost (1 IP, 1 site), /var/www/html/   
**Apache Directory Setup:**  

- The design allows team members to upload html files directly to the html folders without breaking the context of the files and directories. It will also allow Apache to read the files and execute/traverse the folders inside. Team members will also be able to modify any files created or uploaded by other team members in the public_html. 
- All new files or directories placed in the DocumentRoot will have a group webadmin
- "Other" is given read access to files and directories.
- "Other" is given execute access to directories. 
Special Groups: Webadmins - allows read and write access to the DocumentRoot for uploading websites files.

***Firewall Ports:***  
- The requirements below will be translated in the appropriate security groups:

	Public Subnet
		Ingress: 
			80, 443 - Anywhere			- Application Load Balancer
			80, 443 - Private Subnet	- NAT Instance
			22		- Anywhere			- Bastion Host
		Egress
			80, 443 - Anywhere			- Application Load Balancer
			22		- Private Subnet	- Bastion Host
	Private Subnet:
		Ingress:
			22		- Bastion Host		- Ec2 WebServers
			80, 443	- ALB				- Ec2 WebServers
		Egress:
			22		- Bastion Host		- Ec2 WebServers
			80, 443	- NAT Instance		- Ec2 WebServers


***Ansible***

- Ansible Controller will reside in each team members workstation as an Ubuntu VM
- Authentication Mechanisms:
	- Private Public Key Pairing: Ubuntu controller, GitHub, AWS EC2 Instances (Bastion, Webs, NAT)
	- SSH Agent (Forwarder)
	- AWS Profile (awscli)
- Connectivity:
	- ssh proxy command in ~/.ssh/config
- Inventory:
	- Dynamic Inventory via ec2.py and AWS tags
	- ec2.ini : configured to use private ip’s of ec2 instances
- Playbooks:
	- ec2config.yml
		- All:
			- Add Keypairs
		- Webservers:
			- Apache Configuration
		- Bastion Host
			- epel-release
			- fail2ban
	- blogbuild.yml (extra: buildsite bash script)
		- Ec2 Webservers
			- Unarchive the blog.tar.gz (generated and packaged by buildsite script) to all the Webservers





## Others ##

***Alternatives Considered:***  
Pairing a private and public subnet so that they are placed on the same availability zone while other pairings will be on a different availability zone. This alternative has not been chosen to allow the team experience of the limitation of separating all subnets on their own availability zones.

We also considered using Ubuntu Instance as our Webserver. 


***Security Concerns:***  
- "Others" has been given read access to all files in public_html folders. Since these files are available anyway to the public via the website, security should not be a concern. However, it is good to note that this might present a future issue. 