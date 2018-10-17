resource "aws_ecs_service" "sbw-ecs-service-staging" {
  	name            = "sbw-ecs-service-staging"
  	iam_role = "${aws_iam_role.ecs-service-role.name}"
  	cluster         = "${aws_ecs_cluster.sbw-ecs-cluster.id}"
  	task_definition = "${aws_ecs_task_definition.sbw-task-staging.family}:${max("${aws_ecs_task_definition.sbw-task-staging.revision}", "${data.aws_ecs_task_definition.sbw-task-staging.revision}")}"
  	desired_count   = 2

  	load_balancer {
    	target_group_arn  = "${aws_alb_target_group.sbw-ecs-target-group-staging.arn}"
    	container_port    = 80
    	container_name    = "sbw-frontend-staging"
	}
}