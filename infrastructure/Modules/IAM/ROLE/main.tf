#******** IAM ROLE ******

# ---- ECS ROLE ----
resource "aws_iam_role" "ECS_ROLE" {
  name               = "ECS-ROLE-${var.ENVIRONMENT}"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

  tags = {
    Name       = "ECS-ROLE-${var.ENVIRONMENT}"
    Created_by = "Terraform"
  }
  lifecycle {
    create_before_destroy = true
  }
}


# ----------------------------
# -----   Attachment     -----
# ----------------------------


# ---- Attachment policy for CodeDeploy role ----

resource "aws_iam_role_policy_attachment" "attachment1" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  role       = "${aws_iam_role.ECS_ROLE.name}"
  lifecycle {
    create_before_destroy = true
  }
}

