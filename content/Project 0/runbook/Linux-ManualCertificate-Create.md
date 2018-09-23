+++
title = "How to Generate CSR using OpenSSL"
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
# **How to Generate CSR using OpenSSL** #

## Goal: ##
Create CSR
Generate Cert
Install Cert on any server or application

## Workflow: Login ##
1. Create a file called terraform.tfvars 


## Specs: ##
1.


## Instructions ##

1. Install OpenSSL 
	1. If Windows, create System Environment Variable:  
	name: OPENSSL_CONF   
	Value: C:\Program Files (x86)\GnuWin32\share\openssl.cnf
2. Generate CSR: 
  
		openssl req -out sandboxworms.csr -new -newkey rsa:2048 -nodes -keyout sandboxwormsKey.key
	 
3. Follow OnScreen instructions
4. Upload CSR to Certificate Provider
5. Keep the sandboxwormsKey.key in a safe storage 




