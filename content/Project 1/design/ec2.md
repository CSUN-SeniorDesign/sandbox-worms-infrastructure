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
- High-Availa
- Load Balanced services   
- insert more  

***Background:***  
The system is being designed by CSUN students who have very limited experience in most of the technology being used. Therefore, constant downtime during the project deployment as team members collaborate is to be expected. It should also be noted that although the implementation is small, many of the design choices will be made in consideration of possible future growth and potential real-life use. 

We will refer to Amazon Web Services as AWS. Production account will be referred to the AWS account that will be submitted to the professor for grading.

***High-Level Design:***     
In setting up the project, the team needs collaboration tools and IT infrastructure. Github will be used for code repository, file sharing, documentations repository and project management. Github was chosen because it was free, flexible, provided as SaaS, and offers a limited but fit for our purpose, project management. Slack will be used for daily team conversation. AWS will be used as the infrastructure and other needed SaaS. 

AWS network infrastructure was setup so that future high-availability for the services could be achieved. Each team members has its own AWS account that belongs to the Team's AWS organization. One account was chosen to be the production, in our case the account to be graded.  


***Detailed Design:***  
*Team Members Workflow:*  
Each team member will setup a the repository locally. A pull request will need to be submitted for any change. At least 1 team member will need to do a peer review of the change and approve the merge. For tasks or issues that must be done on AWS, each team member will simulate or practice the change on their own account. When ready, changes can be done on the production account. Uploading of files will be done thru SCP.

*AWS Network Infrastructure*  
Production account will use Virginia Region. Refer to the [diagram](https://docs.sandboxworms.me/design/). 6 Subnets were created on their own availability zones. An AWS Internet Gateway has been setup to allow inbound and outbound access from and to the EC2 instance in the public subnets. 

AWS Route 53 will be used as a nameserver for the Sandboxworms.me domain. 

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