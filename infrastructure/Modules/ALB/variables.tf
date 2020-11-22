####  Variables  ######

variable "ENVIRONMENT" {
  type = string
}

variable "SUBNETS" {
  type = list
}

variable "SECURITY_GROUP" {
  type = string
}

variable "INTERNAL" {
  default = false
}

variable "RANDOM_ID" {
  type = string
}

variable "TARGET_GROUP" {
  type = string
}

variable "ENABLE_LOGS" {
  type    = bool
  default = false
}

variable "IDLE_TIMEOUT" {
  type    = number
  default = 60
}

variable "CERT_ARN" {
  type = string
}
