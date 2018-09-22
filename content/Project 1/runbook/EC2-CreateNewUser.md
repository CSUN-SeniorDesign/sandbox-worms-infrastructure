+++
title = "Create New User in EC2 Instance"
description = ""
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
# **Create New User In EC2 Instance** #

## Goal: ##
The goal is to create a user for each member of the team so that no sharing of credentials happen. 

## Workflow: Login ##
1. Open Putty 
1. Input username@www.sandboxworms.me as Host Name
1. Under SSH -> Auth , specify the Private Key

## Specs: ##
1. No Password Login
2. No Password Sudo
3. Different Private and Public Key for each user
4. Home directory created

## Instructions ##
### Create Key Pair in AWS EC2 ###
1. Login to AWS Console : 429784283093.signin.aws.amazon.com/console
2. Go to Services -> EC2
3. Go to Key Pairs
4. Create Key Pair
5. Give it a Name
6. Download the Private Key

### Create Public Key and Convert Private Key to PPK ###
1. Open PuttyGen (Install Putty if you do not have it)
2. Press Load
3. Select the private key
4. Click Save Public Key as .pem
5. Click ok to saving without passphrase
6. Click Save Private Key
7. Select .ppk extension

### Create user in EC2  ###
1. Login to EC2 instance
2. sudo useradd yerden -d /home/yerden
3. sudo vi /etc/sudoers
4. Add this to the bottom of the textfile
	- yerden          ALL=(ALL)       NOPASSWD: ALL
5.  sudo su yerden
6.  cd /home/yerden
7.  mkdir .ssh
8.  chmod 700 .ssh
9.  touch .ssh/authorized_keys
10. chmod 600 .ssh/authorized_keys
11. vi .ssh/authorized_keys
12. Open the public key using notepad
13. Format it so it looks like this:
	- ssh-rsa AAAAB3NzaC1yc2EAAAA... Yerden
	- the ... indicates the remaining parts of the public key. make sure they are all in one line. Remove the new line. 



