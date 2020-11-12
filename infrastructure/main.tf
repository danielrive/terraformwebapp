# # #   Providers # # #

provider "aws" {
  profile    = "${var.AWS_PROFILE}"
  region     = "${var.AWS_REGION}"
}

resource "random_id" "random_id" {
  byte_length = "2"
}


# # #   Networking  # # #


module "Networking" {
  source         = "./Modules/Networking"
  CIDR           = ["10.100.0.0/16"]
  Environment    = "${var.ENVIRONMENT_NAME}"
}


# # # Security Group ALB # # #

module "SG_ALB" {
  source          = "../Modules/Security_Group"
  ENVIRONMENT     = "${var.ENVIRONMENT_NAME}"
  VPC             = module.Networking.VPC_ID
  PORT_TO_ALLOW   = 80
  CIDRs_TO_ALLOW  = ["0.0.0.0/0"]
}


# # # Target Group # # #

module "Target_WebAPP" {
  source             = "../Modules/TargetGroup"
  ENVIRONMENT        = "${var.ENVIRONMENT_NAME}"
  TG_PORT            = 80
  VPC                = module.Networkings.VPC_ID
  PATH               = "/v1/health"
  PORT_HEALTH_CHECKS = "3000"
  TARGET_TYPE        = "ip"
}


# # # ALB  # # #

module "ALB_WEBAPP" {
  source           = "../Modules/ALB"
  ENVIRONMENT      = "${var.ENVIRONMENT_NAME}"
  SUBNETS          = [module.Networking.SubnetPublics[0],module.Networking.SubnetPublics[1]]
  SECURITY_GROUP   = module.SG_ALB.SG_ID
  INTERNAL         = false
  RANDOM_ID        = "${random_id.random_id.hex}"
  TARGET_GROUP     = module.Target_WebAPP.TargetGroup_ARN
  ENABLE_LOGS      = false
}

# # # ECS Cluster # # #

module "ECS_Cluster_WEBAPP" {
  source      = "../Modules/ECS/Cluster"
  Environment = "${var.ENVIRONMENT_NAME}"
}

# # # ECS Task Definition # # #


# # # ECS Service # # #