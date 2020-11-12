output "ARN_Cluster" {
   value = aws_ecs_cluster.CLUSTER.id
}

output "Cluster_Name" {
   value = aws_ecs_cluster.CLUSTER.name
}
