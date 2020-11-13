## Variables 

variable "ENVIRONMENT"{
  type = "string"    
}

variable "SG_NAME"{
  type = "string"    
}

variable "VPC"{
  type = "string"    
}

variable "PORT_TO_ALLOW"{
  type = number    
}

variable "CIDRs_TO_ALLOW"{
  type = "list"    
}

variable "SG_TO_ALLOW"{
  type = "list"
  default = []
}


