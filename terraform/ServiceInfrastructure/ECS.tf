data "aws_ecs_task_definition" "clustertask" {
  task_definition = "${aws_ecs_task_definition.clustertask.family}"
}


#===================CLUSTER==================
resource "aws_ecs_cluster" "SBW-terraform-cluster" {
  name = "SBW-terraform-cluster"
}

#===================TASK DEFINITION==================
resource "aws_ecs_task_definition" "clustertask" {
  family                = "clustertask"
  container_definitions = "${file("task-definitions/service.json")}"
  
  placement_constraints {
    type       = "memberOf"
    expression = "attribute:ecs.availability-zone in [us-east-1a, us-east-1b]"
  }
  
#  task_role_arn		=	"arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role" 
#  execution_role_arn	=	"arn:aws:iam::429784283093:role/ecsTaskExecutionRole"  
}

#===================SERVICE==================
resource "aws_ecs_service" "SBW-Cluster-ALB" {
  name            = "SBW-Cluster-ALB"
  cluster         = "${aws_ecs_cluster.SBW-terraform-cluster.id}"
#  task_definition = "aws_ecs_task_definition.clustertask.arn"
  task_definition = "${aws_ecs_task_definition.clustertask.family}:${max("${aws_ecs_task_definition.clustertask.revision}", "${data.aws_ecs_task_definition.clustertask.revision}")}"
  desired_count   = 3
  iam_role        = "arn:aws:iam::429784283093:role/ecsTaskExecutionRole"

  load_balancer {
#    target_group_arn = "aws_lb_target_group.sandbox-target.arn"
	target_group_arn = "arn:aws:elasticloadbalancing:us-east-1:429784283093:targetgroup/ecs-SBW-Cl-SB-ALB/da32f7059dd79168"
    container_name   = "cluster-task"
    container_port   = 80
  }

  placement_constraints {
    type       = "memberOf"
    expression = "attribute:ecs.availability-zone in [us-east-1a, us-east-1b]"
  }
}
/*
resource "aws_ecs_service" "test-ecs-service" {
  	name            = "test-ecs-service"
  	iam_role        = "arn:aws:iam::429784283093:role/ecsTaskExecutionRole"
  	cluster         = "${aws_ecs_cluster.SBW-terraform-cluster.id}"
  	task_definition = "${aws_ecs_task_definition.clustertask.family}:${max("${aws_ecs_task_definition.clustertask.revision}", "${data.aws_ecs_task_definition.clustertask.revision}")}"
  	desired_count   = 2

  	load_balancer {
    	target_group_arn  = "aws_alb_target_group.sandbox-target.arn"
    	container_port    = 80
    	container_name    = "wordpress"
	}
}
*/
#===================ECR REPO==================
/*
resource "aws_ecr_repository" "SBW-repo" {
  name = "SBW-repo"
}
*/
