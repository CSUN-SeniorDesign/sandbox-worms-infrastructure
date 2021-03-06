data "aws_ecs_task_definition" "sbw-task-staging" {
  task_definition = "${aws_ecs_task_definition.sbw-task-staging.family}"
   depends_on = [ "aws_ecs_task_definition.sbw-task-staging" ]
}

resource "aws_ecs_task_definition" "sbw-task-staging" {
    family                = "sbw-task-staging"
    network_mode          = "bridge"
	task_role_arn 		  = "arn:aws:iam::429784283093:role/ecsTaskExecutionRole"
    container_definitions = <<DEFINITION
[
  {
    "name": "sbw-frontend-staging",
    "image": "429784283093.dkr.ecr.us-east-1.amazonaws.com/sandboxworms:staging",
    "essential": true,
    "portMappings": [
      {
        "containerPort": 80,
        "hostPort": 80
      }
    ],
    "memory": 500,
    "cpu": 10
  }
]
DEFINITION
}