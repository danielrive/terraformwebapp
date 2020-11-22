#### Outputs VPC Resources ####

# ------ VPC ID ------
output "VPC_ID" {
  value = aws_vpc.VPC.id
}

# ------ Subnets Publics ------
output "SubnetPublics" {
  value = [aws_subnet.PUBLIC_SUBNETs[0].id, aws_subnet.PUBLIC_SUBNETs[1].id]
}

# ------ Subnets Private ------
output "SubnetPrivates" {
  value = [aws_subnet.PRIVATE_SUBNETs[0].id, aws_subnet.PRIVATE_SUBNETs[1].id]
}
