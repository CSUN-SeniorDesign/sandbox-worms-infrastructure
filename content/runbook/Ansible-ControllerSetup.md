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

## Goal: ##
Setup a consistent ansible controller across different team members

## Workflow: Login ##
1. Install Ansible Controller
2. Configure Ansible to work with AWS
	- Set Environment variable
	- Install Ec2.py and Ec2.ini


## Specs: ##
1. Install Ansible with modules for AWS and others
2. No password for admin user. Use Private key


## Instructions ##

1. Set VM to Bridged Adapter
2. Install CENTOS - minimal Install
3. Set root password
4. Set admin account - no password
5. Change Hostname- sudo vi /etc/hostname
6. ### Create user in EC2  ###
7. Login to EC2 instance
8. sudo useradd yerden -d /home/yerden
9. sudo vi /etc/sudoers
10. Add this to the bottom of the textfile
	- yerden          ALL=(ALL)       NOPASSWD: ALL
11.  sudo su yerden
12.  cd /home/yerden
13.  mkdir .ssh
14.  chmod 700 .ssh
15.  touch .ssh/authorized_keys
16. chmod 600 .ssh/authorized_keys
17. vi .ssh/authorized_keys
18. Open the public key using notepad
19. Format it so it looks like this:
	- ssh-rsa AAAAB3NzaC1yc2EAAAA... Yerden
	- the ... indicates the remaining parts of the public key. make sure they are all in one line. Remove the new line. 
20. sudo vi /etc/ssh/sshd_config
	- PasswordAuthentication no
	- PermitRootLogin no

21. systemctl restart sshd.service
22. sudo yum update
23. sudo yum install ansible
24. cat /etc/ansible/ansible.cfg - look at ansible config
25. sudo yum install epel-release
26. sudo yum install python-pip
27. sudo pip install boto
28. sudo pip install boto3
29. sudo pip install paramiko
30. sudo pip install PyYAML
31. sudo pip install Jinja2
32. sudo pip install httplib2
33. sudo pip install six


### Ansible Configuration ###
1. Configure environment variable for AWS

		export AWS_ACCESS_KEY_ID='YOUR_AWS_API_KEY'
		export AWS_SECRET_ACCESS_KEY='YOUR_AWS_API_SECRET_KEY'
2. Download require script for dynamic inventory of EC2 instances

		sudo curl -o ec2.py https://raw.githubusercontent.com/ansible/ansible/devel/contrib/inventory/ec2.py
		sudo curl -o ec2.ini https://raw.githubusercontent.com/ansible/ansible/devel/contrib/inventory/ec2.ini
		sudo chmod a+x ec2.py
		sudo chmod +x ec2.py


3. This tells ec2.py where the ec2.ini config file is located.

		export EC2_INI_PATH=/etc/ansible/ec2.ini 
		#export ANSIBLE_HOSTS=/etc/ansible/ec2.py
		export ANSIBLE_INVENTORY=/etc/ansible/ec2.py

4. Configure SSH-Agent Forwarding
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



5. ./ec2.py -> should return inventory
6. ansible -m ping tag_Name_Aubrey01 -u ec2-user -> tag_*tagname*_*tagvalue*
7. ansible  -m ping all -u ec2-user -> -vvv debugging


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
