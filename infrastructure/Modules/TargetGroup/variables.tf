#####  Variables  #####

variable "ENVIRONMENT"{
  type = "string"    
}

variable "TG_PORT"{
    type = "string"
}

variable "VPC" {
    type = "string"
}

variable "PATH"{
  type = "string"
  default = "/"  
}

variable "PORT_HEALTH_CHECKS" {
  type = "string"
}

variable "TARGET_TYPE"{
  type = "string"    
}

variable "PROTOCOL"{
  type = "string"
  default = "HTTP"    
}