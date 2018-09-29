+++
title = "Ansible Controller Setup"
description = ""
weight = 90
# Type of content, set "slide" to display it fullscreen with reveal.js
type="page"
date = "2018-09-14"
# Creator's Display name
creatordisplayname = "Aubrey Nigoza"
# Creator's Email
creatoremail = "aubrey.nigoza.34@my.csun.edu"
# LastModifier's Display name
lastmodifierdisplayname = ""
# LastModifier's Email
lastmodifieremail = ""
tags = ["aws", "ansible", "centos", "howto"]
+++
# **Setup Ansible Controller** #
Rev. 2

## Goal: ##
Setup a consistent ansible controller across different team members

## Workflow: Login ##
1. Install Ansible Controller (Ubuntu)
2. Configure Ansible to work with AWS
	- Set Environment variable
	- Install Ec2.py and Ec2.ini
3. Clone Repos
4. Pull latest Repo
5. Run Hugo from the blogpost repo
6. Run Ansible from the infrastructure_repo/ansible


## Specs: ##
1. Install Ansible with modules for AWS and others
2. No password for admin user. Use Private key


## Setup Instructions ##

###Ubuntu Setup###
1. Install latest server
2. server snaps to add:
	1. powershell
	2. aws-cli
	3. amazon-ssm-agent
4. sudo add apt-repository universe
5. sudo apt-get update
5. sudo apt-update
6. sudo apt-upgrade
7. follow ansible setup guide
8. sudo snap install hugo --channel=extended
9. curl -L https://github.com/aubreynigoza.keys >> .ssh/authorized_keys
10. chmod 700 .ssh/authorized_keys
11. sudo pip install boto
12. sudo pip install boto3
13. sudo pip install paramiko
14. sudo pip install PyYAML
15. sudo pip install Jinja2
16. sudo pip install httplib2
17. sudo pip install six
18. sudo vi /etc/sudoers
19. Add this to the bottom of the textfile
	- yerden          ALL=(ALL)       NOPASSWD: ALL
20. sudo vi /etc/ssh/sshd_config
	- PasswordAuthentication no
	- PermitRootLogin no
21. awsconfig
	- follow prompt to save your credential

**Copy private key to controller:**
1. vi ~/.ssh/id_rsa
2. paste private key
3. save it
4. chmod 400 .ssh/id_rsa

**Start ssh agent**

1. eval \`ssh-agent\`
2. ssh-add ~/.ssh/id_rsa or ssh-add 

**Clone Repos**

1. cd ~
2. mkdir repo
3. cd repo
4. git config --global user.name "aubreynigoza"
5. git config --global user.email "aubrey.nigoza.34@my.csun.edu"
5. git clone https://github.com/CSUN-SeniorDesign/sandbox-worms-infrastructure.git
6. cd sandbox-worms-infrastructure
7. git remote set-url origin git@github.com:CSUN-SeniorDesign/sandbox-worms-infrastructure.git
8. Repeat for blog
9. For blog, clone the theme folder as well:   https://github.com/Lednerb/bilberry-hugo-theme.git


### Certbot Configuration ###

	sudo apt-get update
	sudo apt-get install software-properties-common
	sudo add-apt-repository ppa:certbot/certbot
	sudo apt-get update
	sudo apt-get install python-certbot-apache 
	sudo apt-get update && sudo apt-get -y upgrade
	sudo apt-get install python-pip
	mkdir ~/certbot/
	mkdir ~/certbot/log
	mkdir ~/certbot/config
	mkdir ~/certbot/work
	certbot certonly -d sandboxworms.me -d *.sandboxworms.me --dns-route53 --logs-dir ~/certbot/log/ --config-dir ~/certbot/config/ --work-dir ~/certbot/work/ -m aubrey.nigoza.34@my.csun.edu --agree-tos --non-interactive --server https://acme-v02.api.letsencrypt.org/directory
	sudo apt install python3-pip
	pip3 install certbot-dns-route53

A short explanation of the above command  
certonly: This means only create the certificate instead of updating the server config and/or restarting the server. I didn’t use this when creating a normal SSL certificate, and I’m not sure if it’s necessary for a wildcard cert or not, but I found it works.  
-d: This specified what domains you wish to register with the certificate. You can pass more than one of these at a time. Before wildcard certificates you’d have to pass one of these for each subdomain you were using.  
--dns-route53: this specifies that we want to use the plugin to verify that we control the DNS for the domain. DNS validation is the only way to validate wildcard certificates.  
--logs-dir,--work-dir,--config-dir: points to a directory, allowing the certbot command to be run without sudo permission.  
-m: set the email address.  
--agree-tos: agrees to the terms and conditions.  
--non-interactive: stops it from asking you for stuff. This is intended for using the command in an automated script for example.
--server: manually point to the server that allows wildcard certificates. The default server that it uses without this command does not support wildcard certificates at the time of this article being published.
Once you run the command, if it was successful, the new certificate files should be saved in the following folder if your using the same configuration as I did /home/username/letsencrypt/config/live/example.com/. There should be two files in the folder, on called fullchain.pem and another called privkey.pem.
	
	
### Ansible Configuration ###

1. Download require script for dynamic inventory of EC2 instances (Deprecated Setup - could be followed to download another copy of the files below but they exists in our repo already)

		sudo curl -o ec2.py https://raw.githubusercontent.com/ansible/ansible/devel/contrib/inventory/ec2.py
		sudo curl -o ec2.ini https://raw.githubusercontent.com/ansible/ansible/devel/contrib/inventory/ec2.ini
		sudo chmod a+x ec2.py
		sudo chmod +x ec2.py


2. This tells ec2.py where the ec2.ini config file is located. (Deprecated Setup - do not follow)

		export EC2_INI_PATH=/etc/ansible/ec2.ini 
		export ANSIBLE_INVENTORY=/etc/ansible/ec2.py

4. Configure SSH-Agent Forwarding (Deprecated Setup - 'Start Agent' setup above will do this)
	- Copy Public key of the ec2 instance to ~/.ssh/keypair.pem

			ssh-agent bash
			ssh-add ~/.ssh/keypair.pem 
			-----BEGIN RSA PRIVATE KEY-----
			MIIEogIBAAKCAQEA4jjxq4dUcArsZgu3PUfZ4Dal71OpBmpLVGeQ3PfdPBkySgYQAKF66g/fDdd+
			VidDv+ts528OsmRjvoKAQfpmOvg1RzXC9aUDwXYFBp0RPKT3/tDFj4Q/1DCx4d7ohj3tXc1I7+LB
			D3ERj//iNBThNaxRENaFtqcvYjkgQ9Cm ....
			-----END RSA PRIVATE KEY-----
			chown anigoza aubrey-temp.pem
			chmod 400 aubrey-temp.pem




#### Ansible Ad-Hoc Commands Sample ####
Run from sand-boxworms-infrastructure/ansible

	inventory/ec2.py 
	ansible -m ping tag_Type_BastionHost #tag_*tagname*_*tagvalue*
	ansible  -m ping all -u ec2-user -vvv #debugging full details


### Running First Playbook ###
	ansible-playbook -i /etc/ansible/ec2.py --limit "tag_Type_WebServer"  httpd.yml


### Troubleshooting ###
- ppk must be converted to pem
- environment variables must be added every reboot
- ssh-agent must be redone
- edit .ssh/config with bastion host public ip

### Useful Links ###


- https://github.com/digembok/devops
- https://medium.com/happy5/aws-dynamic-inventory-and-ansible-thank-god-i-can-sleep-more-4d2aeadbc6f
- https://developer.github.com/v3/guides/using-ssh-agent-forwarding/
- https://linoxide.com/tools/setup-ansible-centos-7/
- https://medium.com/@dhoeric/ansible-dynamic-inventory-with-aws-ec2-80d075fcf430
- https://www.redhat.com/en/blog/system-administrators-guide-getting-started-ansible-fast
- https://docs.ansible.com/ansible/2.4/become.html



