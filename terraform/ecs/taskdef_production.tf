data "aws_ecs_task_definition" "sbw-task-production" {
  task_definition = "${aws_ecs_task_definition.sbw-task-production.family}"
   depends_on = [ "aws_ecs_task_definition.sbw-task-production" ]
}

resource "aws_ecs_task_definition" "sbw-task-production" {
    family                = "sbw-task-production"
    network_mode          = "bridge"
    container_definitions = <<DEFINITION
[
  {
    "name": "sbw-frontend",
    "image": "429784283093.dkr.ecr.us-east-1.amazonaws.com/sandboxworms:production",
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