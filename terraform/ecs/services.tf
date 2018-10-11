resource "aws_ecs_service" "sbw-ecs-service" {
  	name            = "sbw-ecs-service"
  	iam_role = "${aws_iam_role.ecs-service-role.name}"
  	cluster         = "${aws_ecs_cluster.sbw-ecs-cluster.id}"
  	task_definition = "${aws_ecs_task_definition.sbw-blog.family}:${max("${aws_ecs_task_definition.sbw-blog.revision}", "${data.aws_ecs_task_definition.sbw-blog.revision}")}"
  	desired_count   = 2

  	load_balancer {
    	target_group_arn  = "${aws_alb_target_group.sbw-ecs-target-group.arn}"
    	container_port    = 80
    	container_name    = "sbw-frontend"
	}
}