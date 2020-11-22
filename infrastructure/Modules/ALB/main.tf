#************ ALB Resources **********


#---------- ALB Creation ----------

resource "aws_alb" "ALB" {
  name               = "ALB-${var.ENVIRONMENT}-${var.RANDOM_ID}"
  subnets            = [var.SUBNETS[0], var.SUBNETS[1]]
  security_groups    = [var.SECURITY_GROUP]
  load_balancer_type = "application"
  internal           = var.INTERNAL
  enable_http2       = true
  idle_timeout       = var.IDLE_TIMEOUT
  access_logs {
    bucket  = "alb-logs-${var.ENVIRONMENT}-${var.RANDOM_ID}"
    prefix  = var.ENVIRONMENT
    enabled = var.ENABLE_LOGS
  }
  tags = {
    Created_by = "Terraform"
  }
}

#---------- Listener HTTP ----------

resource "aws_alb_listener" "HTTP_LISTENER" {
  load_balancer_arn = aws_alb.ALB.id
  port              = "80"
  protocol          = "HTTP"
  default_action {
    target_group_arn = var.TARGET_GROUP
    type             = "forward"
  }
  depends_on = [aws_alb.ALB]

}

#---------- Listener HTTPS ----------

resource "aws_alb_listener" "HTTPS_LISTENER" {
  load_balancer_arn = aws_alb.ALB.id
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-Ext-2018-06"
  certificate_arn   = var.CERT_ARN
  default_action {
    target_group_arn = var.TARGET_GROUP
    type             = "forward"
  }
  depends_on = [aws_alb.ALB]

}
