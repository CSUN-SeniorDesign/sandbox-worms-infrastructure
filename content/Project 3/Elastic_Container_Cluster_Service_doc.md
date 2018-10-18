---
title: "Elastic Container Cluster Service Documentation"
date: 2018-10-11T17:56:09-07:00
draft: false
Categories: [Project 3, Documentation]
Tags: [Documentation]
Author: "John Vinuya"
---

Amazon Elastic Container Cluster Service provides the infrastructure needed for implementing containers and images built by Docker in the Elastic Container Registry.

## Goal: ##
Create a cluster that accommodates containers to be placed in the ECS instances based on the specifications set by a Dockerfile.

## Setup Instructions + Workflow: Cluster, Dockerfile Pipeline ##
1. Using terraform, create a cluster resource.
2. Check the ECR repository if an image is available.
3. Create a task definition, this will attach an image from the ECR within the JSON portion. You can also define memory specification in the JSON portion too.
4. Create an IAM Role specifically for ECS. If needed, create a policy document allowing ECS to assume the role. Create an instance profile as well to allow the ECS instances to assume the role.
5. Create an ECS Service, specify the IAM Role, task definition, and cluster. In the load balancer block, specify the target group and container name.
6. Create an Autoscaling Group, add the following to add the cluster agent.
	user_data = <<EOF
                #!/bin/bash
                echo ECS_CLUSTER=${var.ecs_cluster} >> /etc/ecs/ecs.config
                EOF
7. Create a Launch configuration.
8. Plan and Apply to verify the addition of new resources.	

## Specs: ##
1. Have Docker installed to create a Docker file, have it pushed to the ECR repository.

### Troubleshooting ###
- If using terraform, ensure all provisions are made to accommodate additional instances (ALB, Listener Rules, ECS Security Groups, Roles, Policies, etc.)

### Useful Links ###
- http://blog.shippable.com/setup-a-container-cluster-on-aws-with-terraform-part-2-provision-a-cluster
- https://docs.aws.amazon.com/AmazonECS/latest/developerguide/instance_IAM_role.html