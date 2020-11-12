#******** ECS Cluster ******

#---------- ECS Cluster  ----------
resource "aws_ecs_cluster" "CLUSTER" {
  name = "Cluster-${var.ENVIRONMENT}"
  tags = {
    Created_by = "Terraform"
  }
}