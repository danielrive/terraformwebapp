#******** Target Group ******

resource "aws_alb_target_group" "TG_GROUP" {
  name                 = "TG-${var.ENVIRONMENT}"
  port                 = var.TG_PORT
  protocol             = var.PROTOCOL
  vpc_id               = var.VPC
  target_type          = var.TARGET_TYPE
  deregistration_delay = 5
  health_check {
    enabled             = true
    interval            = 5
    path                = var.PATH
    port                = var.PORT_HEALTH_CHECKS
    protocol            = var.PROTOCOL
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 3
    matcher             = "200,302"
  }
  lifecycle {
    create_before_destroy = true
  }
  tags = {
    Created_by = "Terraform"
  }
}
