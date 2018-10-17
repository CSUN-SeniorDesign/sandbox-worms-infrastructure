import boto3
import botocore
import pprint
import os

region = "us-east-1"
ecr_client = boto3.client('ecr')
s3 = boto3.resource('s3')
ecs_client = boto3.client('ecs', region_name=region)

def lambda_handler(event, context):
    if event:
        print("Event : ", event)
        file_obj = event["Records"][0]
        filename = str(file_obj['s3']['object']['key'])
        print("Filename: ", filename)
        object = s3.Object('sandboxworms-packages-92618', filename)
        response = object.get()
        imagesha=object.get()['Body'].read().decode('utf-8').rstrip("\n")
        manifest=get_manifest(imagesha)
        if filename == "master/prodbuild.txt":
            tag_name = "production"
            service_name = "sbw-ecs-service-production"
            task_defintion = "sbw-task-production"
            task_family = "sbw-task-production"
            container_name = "sbw-frontend-production"
        else:
            tag_name = "staging"
            service_name = "sbw-ecs-service-staging"
            task_defintion = "sbw-task-staging"
            task_family = "sbw-task-staging"
            container_name = "sbw-frontend-staging"
        try:
            tag_image(manifest, tag_name)
        except Exception:
            print("Image already tagged")
        
        revision = revise_task_definition(tag_name, task_family, container_name)
        taskDefinitionRev = task_defintion + ':' + str(revision)
        update_sbw_service(taskDefinitionRev, service_name)

def revise_task_definition (tag_name, task_family, container_name): 
    response = ecs_client.register_task_definition(
        family=task_family,
        #taskRoleArn='string',
        networkMode='bridge',
        containerDefinitions=[
            {
                'name': container_name ,
                'image': '429784283093.dkr.ecr.us-east-1.amazonaws.com/sandboxworms:' + tag_name,
                'cpu': 1024,
                'memory': 512,
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
    return (response['taskDefinition']['revision'])
    
def update_sbw_service (taskDefinitionRev, service_name):
        
    #print taskDefinition
    response = ecs_client.update_service(
        cluster='sbw-ecs-cluster',
        service= service_name,
        desiredCount=1,
        taskDefinition=taskDefinitionRev,
        deploymentConfiguration={
            'maximumPercent': 200,
            'minimumHealthyPercent': 50
        }
    )
    #pprint.pprint(response)
    print ("service updated")


def get_manifest(imagesha):
    response = ecr_client.batch_get_image(
        registryId='429784283093',
        repositoryName='sandboxworms',
        imageIds=[
            {
                'imageTag': imagesha
            },
        ],
    )
    return response
    
def tag_image(manifest, tag_name):
    response = ecr_client.put_image(
        registryId='429784283093',
        repositoryName='sandboxworms',
        imageManifest=manifest['images'][0]['imageManifest'],
        imageTag=tag_name
    )    