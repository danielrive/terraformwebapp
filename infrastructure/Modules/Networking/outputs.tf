#### Outputs VPC Resources ####

# ------ VPC ID ------
output "VPC_ID" {
    value = aws_vpc.VPC.id
}

# ------ Subnets Publics ------
output "SubnetPublics" {
    value = [aws_subnet.PUBLIC_SUBNET_1.id,aws_subnet.PUBLIC_SUBNET_2.id]
}

# ------ Subnets Private ------
output "SubnetPrivates" {
        value = [aws_subnet.PRIVATE_SUBNET_1.id,aws_subnet.PRIVATE_SUBNET_2.id]
}