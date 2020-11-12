#**** Security Group Resources ****


# ---- Security Group for ALB  ----
resource "aws_security_group" "SG" {
  name        = "SG_${var.SG_NAME}_${var.ENVIRONMENT}"
  description = "Security group for ${var.ENVIRONMENT}"
  vpc_id      = "${var.VPC}"
  tags = {
    Name = "SG_${var.SG_NAME}_${var.ENVIRONMENT}"
    Created_by = "Terraform"
  }

  ingress {
    protocol    = "tcp"
    from_port   = "${var.PORT_TO_ALLOW}"
    to_port     = "${var.PORT_TO_ALLOW}"
    cidr_blocks = ["${var.CIDRs_TO_ALLOW}"]
    security_groups = ["${var.SG_TO_ALLOW}"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}