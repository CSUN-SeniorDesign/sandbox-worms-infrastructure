import boto3
import pprint
import os

region = "us-east-1"

client = boto3.client('ecr')
response = client.list_images(
    registryId='429784283093',
    repositoryName='sandboxworms',
    maxResults=123
)



client = boto3.client('ecs', region_name=region)

response = client.list_task_definitions(familyPrefix= 'sbw-blog', status='ACTIVE')


#pprint.pprint(response['taskDefinitionArns'][3])
def lambda_handler(event, context):
    response = client.register_task_definition(
        family='sbw-blog',
    #taskRoleArn='string',
        networkMode='bridge',
        containerDefinitions=[
            {
                'name': 'sbw-frontend',
                'image': '429784283093.dkr.ecr.us-east-1.amazonaws.com/sandboxworms:latest',
            #'cpu': 123,
                'memory': 300,
            #'memoryReservation': 123,
            #'links': [
            #    'string',
                'portMappings': [
                    {
                        'containerPort': 80,
                        'hostPort': 80,
                        'protocol': 'tcp'
                    },
                ],
                'essential': True,
            },
        ],
    )
    pprint.pprint(response['taskDefinition']['revision'])
#Update service
    taskDefinitionRev = response['taskDefinition']['family'] + ':' + str(response['taskDefinition']['revision'])
#print taskDefinition
    response = client.update_service(
        cluster='sbw-ecs-cluster',
        service='sbw-ecs-service',
        desiredCount=1,
        taskDefinition=taskDefinitionRev,
        deploymentConfiguration={
            'maximumPercent': 200,
            'minimumHealthyPercent': 50
        }
    )
    #pprint.pprint(response)
    print "service updated"