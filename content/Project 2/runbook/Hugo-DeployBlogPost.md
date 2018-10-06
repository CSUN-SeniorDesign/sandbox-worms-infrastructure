+++
title = "How to Deploy Blog"
description = ""
weight = 3
# Type of content, set "slide" to display it fullscreen with reveal.js
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
tags = ["aws", "vpc", "hugo", "ansible"]
+++
## Deploy Blog Post ##
### Goal ###
The goal is to generate the static html and copy it over to the webserver using Ansible
### Workflow: ###
1. Clone
2. Generate HTML
3. Upload to EC2 Webservers
### Assumptions ###
1. You have followed Ansible Controller Setup Guide
### Instructions ###
1. Login to Ubuntu Controller
2. Pull the latest sandbox-worms-blog repo
3. Run script buildsite
4. Run playbook

		cd ~/repo/sandbox-worms-blog
		git pull origin master
		cd ~/repo/sandbox-worms-infrastructure/ansible
		./buildsite
		ansible-playbook blogbuild.yml 
