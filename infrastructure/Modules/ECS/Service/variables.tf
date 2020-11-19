## Variables 

variable "ALB" {
  type = string
}

variable "ENVIRONMENT" {
  type = string
}

variable "CLUSTER_ID" {
  type = string
}

variable "TF_ID" {
  type = string
}

variable "N_TASKS" {
  type = number
}

variable "SECURITY_GROUP" {
  type = string
}

variable "SUBNETS" {
  type = list
}

variable "TG_ARN" {
  type = string
}

variable "CONTAINER_PORT" {
  type = string
}


