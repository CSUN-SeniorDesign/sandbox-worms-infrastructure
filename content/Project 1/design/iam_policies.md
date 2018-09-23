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