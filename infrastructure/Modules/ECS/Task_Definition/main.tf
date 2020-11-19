#******** ECS Task Definition ******

resource "aws_ecs_task_definition" "ECS_TF" {
  family                   = "TaskDF-${var.ENVIRONMENT}-"
  network_mode             = "awsvpc"
  requires_compatibilities = [var.LAUNCH_TYPE]
  cpu                      = var.CPU
  memory                   = var.MEMORY
  execution_role_arn       = var.ECS_ROLE
  tags = {
    Created_by = "Terraform"
  }
  container_definitions = <<DEFINITION
            [
              {
                "logConfiguration": {
                    "logDriver": "awslogs",
                    "secretOptions": null,
                    "options": {
                      "awslogs-group": "/ecs/TaskDF-${var.ENVIRONMENT}",
                      "awslogs-region": "${var.AWS_REGION}",
                      "awslogs-stream-prefix": "ecs"
                    }
                  },
                "cpu": 0,
                "image": "${var.URL_REPO}",
                "name": "Container-${var.ENVIRONMENT}",
                "networkMode": "awsvpc",
                "portMappings": [
                  {
                    "containerPort": ${var.CONTAINER_PORT},
                    "hostPort": ${var.CONTAINER_PORT}
                  }
                ]
              }
            ]
            DEFINITION
}

#---------- Cloudwatch Log_group  ----------
resource "aws_cloudwatch_log_group" "LOGS_GROUP_ECS" {
  name              = "/ecs/TaskDF-${var.ENVIRONMENT}"
  retention_in_days = 7
}
