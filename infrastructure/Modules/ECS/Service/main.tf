#*****  ECS Service ******

resource "aws_ecs_service" "ECS_SERVICE" {
  depends_on      = [var.ALB]
  name            = "Service-${var.ENVIRONMENT}"
  cluster         = "${var.CLUSTER_ID}"
  task_definition = "${var.TF_ID}"
  desired_count   = "${var.N_TASKS}"
  health_check_grace_period_seconds = 5
  launch_type     = "FARGATE"
  network_configuration {
    security_groups = ["${var.SECURITY_GROUP}"]
    subnets         = ["${var.SUBNETS[0]}","${var.SUBNETS[1]}"]
  }
  load_balancer{
    target_group_arn =  "${var.TG_ARN}"
    container_name   = "Container-${var.ENVIRONMENT}"
    container_port   = "${var.CONTAINER_PORT}"
   }
}