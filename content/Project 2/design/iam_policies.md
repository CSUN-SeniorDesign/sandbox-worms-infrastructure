+++
title = IAM Policies"
description = "Provide IAM Design documentation of the Sandboxworms system"
weight = 1
# Type of content, set "slide" to display it fullscreen with reveal.js
type="page"
date = "2018-10-03"
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
Revision: Project2

**Roles**
Instances will assume a role to gain access to the S3 Bucket
KMS will be used to encrypt the S3 Bucket that holds the webserver files.
The role that will be assumed by the instances will be given access to the KMS.

**Groups:**
IAMFullAccess - Give full access to IAM
AmazonDynamoDBFullAccess - Built-in
TF-Policy - Custom



**TF-Policy**

\# Allows access to s3 bucket and dynamodb table to an IAM


		{
		  "Version": "2012-10-17",
		  "Statement": [
		    {
		      "Sid": "VisualEditor0",
		      "Effect": "Allow",
		      "Action": "s3:ListBucket",
		      "Resource": "arn:aws:s3:::sandboxworms-tf-state-0911"
		    },
		    {
		      "Sid": "VisualEditor1",
		      "Effect": "Allow",
		      "Action": [
		        "s3:PutObject",
		        "s3:GetObject"
		      ],
		      "Resource": "arn:aws:s3:::sandboxworms-tf-state-0911/tf-prod/terraform.tfstate"
		    },
		    {
		      "Sid": "VisualEditor2",
		      "Effect": "Allow",
		      "Action": [
		        "dynamodb:PutItem",
		        "dynamodb:DeleteItem",
		        "dynamodb:GetItem"
		      ],
		      "Resource": "*"
		    }
		  ]
		}