data "aws_ecs_task_definition" "sbw-blog" {
  task_definition = "${aws_ecs_task_definition.sbw-blog.family}"
   depends_on = [ "aws_ecs_task_definition.sbw-blog" ]
}

resource "aws_ecs_task_definition" "sbw-blog" {
    family                = "sbw-blog"
    network_mode          = "bridge"
    container_definitions = <<DEFINITION
[
  {
    "name": "sbw-frontend",
    "image": "429784283093.dkr.ecr.us-east-1.amazonaws.com/sandboxworms:latest",
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