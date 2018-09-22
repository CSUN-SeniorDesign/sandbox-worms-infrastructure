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
**Revision Number:** 1  
**Status:**  

----------
***Executive Summary:***  
Sandboxworms system provides the team members a platform to learn, experiment and practice on multiple technology. It includes, but not limited to Terraform, Ansible, Github, Hugo, Markdown files, Linux Servers, AWS services (EC2, VPC, IGW, Subnets, Route53 etc.), DNS, and Certificates. With the platform in place, team members will be able to apply the theories and principles learned from all the previous CSUN courses. The system will also provide the team members a platfrom to post blogs of their experiences for the week.    

***Goals:***  
- Automation of AWS Infrastructure creation and modification
- Automation of Service Instances configuration
- Improvement in blog posting workflow
- Team-wide consistent setup of different tools and environments (Terraform and Ansible)


***Non-goals:***  
- High-Availability by utilizing multiple availability zones


***Background:***  
The system is being designed by CSUN students who have very limited experience in most of the technology being used. Therefore, constant downtime during the project deployment as team members collaborate is to be expected. It should also be noted that although the implementation is small, many of the design choices will be made in consideration of possible future growth and potential real-life use. 

We will refer to Amazon Web Services as AWS. Production account will be referred to the AWS account that will be submitted to the professor for grading.


***High-Level Design:***     
Although this projects do not use previous implementations from Project 0, it does utilize the knowledge and insight gained from the experience on setting up the AWS infrastructure. We will be using terraform and ansible as our primary tools in completing Project 1. 

Terraform will be used to setup the environment in AWS. Ansible will be used to configure the service infrastructures and deploy new blog post every week. In building up the environment, the goal is to promote portability of the code and avoid static or manual input for the environment to be setup. If manual input is needed, it must be on a separate file to increase visibility.


***Detailed Design:***  
*Team Members Workflow:*  
Each team member will setup a the repository locally. A pull request will need to be submitted for any change. At least 1 team member will need to do a peer review of the change and approve the merge. Application of terraform codes can and should be done at each member's prerogative. This will help in learning the platforms, terraform and ansible.

*Terraform:*  

- All terraform codes must be placed in the terraform subfolder of the   

*EC2 Instance*  
OS: Redhat Linux 7  
Services/Daemon/Modules Installed: httpd, ssl_mod, python-certbot-apache, certbot-dns-route53  
Firewall Ports: 22, 80, 443  
File Security Implemented: File Permission, ACL  
Apache Configuration: NamedVirtualHost (1 IP, multiple sites), /var/www/html/blog/public_html, /var/www/html/docs/public_html, redirect HTTP to HTTPS, disable SSLv2 SSLv3  
Apache Directory Setup: 
- The design allows team members to upload html files directly to the public_html folders without breaking the context of the files and directories. It will also allow Apache to read the files and execute/traverse the folders inside. Team members will also be able to modify any files created or uploaded by other team members in the public_html. 
- All new files or directories placed in the DocumentRoot will have a group webadmin
- "Other" is given read access to files and directories.
- "Other" is given execute access to directories. 
Special Groups: Webadmins - allows read and write access to the DocumentRoot for uploading websites files.

*Firewall Ports*  
- 22 from specific IPs via AWS Security Group  
- 80 from everywhere via AWS Security Group and EC2 instance firewall  
- 443 from everywhere via AWS Security Group and EC2 instance firewall  

***Alternatives Considered:***  
Pairing a private and public subnet so that they are placed on the same availability zone while other pairings will be on a different availability zone. This alternative has not been chosen to allow the team experience of the limitation of separating all subnets on their own availability zones.

We also considered using Ubuntu Instance as our Webserver. 

SFTP was also considered as the protocol for transferring files but since SCP was already enabled, SFTP will be added later.

***Security Concerns:***  
- "Others" has been given read access to all files in public_html folders. Since these files are available anyway to the public via the website, security should not be a concern. However, it is good to note that this might present a future issue. 