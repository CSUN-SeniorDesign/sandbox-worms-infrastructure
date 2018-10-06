---
title: "Hashicorp Packer Documentation"
date: 2018-10-04T14:01:53-07:00
draft: false
Categories: [Project 2, Documentation]
Tags: [Documentation]
Author: "John Vinuya"
---

Hashicorp Packer installation is required on the Ansible Controller if playbooks are to be utilized for the creation of the base AMI.

## Goal: ##
Setup Packer to build the base AMI to be used for the AWS Launch Configuration in the Autoscaling Group.

## Setup Instructions + Workflow: AMI Pipeline ##
1. Install Hashicorp Packer, add directory to PATH.
2. Create a <template>.json file
    - This will serve as the template for the base AMI.
3. If using Ansible playbooks, place <template>.json within playbook directory.
    - Else if specifying on using 
	playbook_dir
	playbook_paths
4. Run $ packer build -var 'aws_access_key=...' -var 'aws_secret_key=...' <template>.json
5. Check if playbook tasks run.

## Specs: ##
1. Define access keys as variables on the top of template.
2. Use CLI cmd to add keys as needed.

### Troubleshooting ###
- Playbook must target specific tag (defined in <template>.json) or use in playbooks:
	hosts: all

### Useful Links ###
- https://www.packer.io/docs/provisioners/ansible.html
- https://www.packer.io/docs/templates/index.html	