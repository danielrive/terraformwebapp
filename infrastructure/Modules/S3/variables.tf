#####  Variables  ######

variable "BUCKET_NAME" {
  type = string
}

variable "ENABLE_WEBSITE" {
  type    = bool
  default = false
}

variable "PATH_INDEX" {
  type    = string
  default = "./"
}


