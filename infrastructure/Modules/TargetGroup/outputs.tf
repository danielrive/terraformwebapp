#### Outputs ####

# ------ TG ARN  ------
output "TargetGroup_ARN" {
   value = aws_alb_target_group.TG_GROUP.arn
}

output "TargetGroup_Name" {
   value = aws_alb_target_group.TG_GROUP.name
}