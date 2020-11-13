# # #   Providers # # #

provider "aws" {
  profile    = "${var.AWS_PROFILE}"
  region     = "${var.AWS_REGION}"
}

resource "random_id" "random_id" {
  byte_length = "2"
}

# # # Account ID  # # #

data "aws_caller_identity" "ID_Current_Account" {}


# # #   Networking  # # #


module "Networking" {
  source         = "./Modules/Networking"
  CIDR           = ["10.100.0.0/16"]
  ENVIRONMENT    = "${var.ENVIRONMENT_NAME}"
}


# # # Security Group ALB # # #

module "SG_ALB" {
  source          = "./Modules/Security_Group"
  ENVIRONMENT     = "${var.ENVIRONMENT_NAME}"
  VPC             = module.Networking.VPC_ID
  PORT_TO_ALLOW   = 80
  CIDRs_TO_ALLOW  = ["0.0.0.0/0"]
  SG_NAME         = "SG_ALB"
}


# # # Target Group # # #

module "Target_WebAPP" {
  source             = "./Modules/TargetGroup"
  ENVIRONMENT        = "${var.ENVIRONMENT_NAME}"
  TG_PORT            = 80
  VPC                = module.Networking.VPC_ID
  PATH               = "/v1/health"
  PORT_HEALTH_CHECKS = "3000"
  TARGET_TYPE        = "ip"
}


# # # ALB  # # #

module "ALB_WEBAPP" {
  source           = "./Modules/ALB"
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
  source      = "./Modules/ECS/Cluster"
  ENVIRONMENT = "${var.ENVIRONMENT_NAME}"
}

# # # ECR REPO # # #

module "ECR_WEBAPP" {
  source        = "./Modules/ECS/ECR"
  ACCOUNT_NAME  = "${data.aws_caller_identity.ID_Current_Account.account_id}"
  ENVIRONMENT   = "${var.ENVIRONMENT_NAME}"
}

# # # IAM ROLE FOR ECS TASK # # #

module "ECS_ROLE_WEBAPP" {
  source       = "./Modules/IAM/ROLE"
  ENVIRONMENT  = "${var.ENVIRONMENT_NAME}"
}

# # # ECS Task Definition # # #

module "ECS_TF_WEBAPP" {
  source          = "./Modules/ECS/Task_Definition"
  ENVIRONMENT     = "${var.ENVIRONMENT_NAME}"
  CPU             = 512
  MEMORY          = 1024
  URL_REPO        = "${module.ECR_WEBAPP.Repo_URL}:develop"
  ECS_ROLE        = module.ECS_ROLE_WEBAPP.ARN_ROLE
  AWS_REGION      =  "${var.AWS_REGION}"
  CONTAINER_PORT  = 9090
  LAUNCH_TYPE     = "FARGATE"
}


module "SG_ECS" {
  source          = "./Modules/Security_Group"
  ENVIRONMENT     = "${var.ENVIRONMENT_NAME}"
  SG_NAME         = "SG_ECS_TASK"
  VPC             = module.Networking.VPC_ID
  PORT_TO_ALLOW   = 80
  CIDRs_TO_ALLOW  = ["0.0.0.0/0"]
}

# # # ECS Service # # #

module "ECS_SERVICE_WEBAPP" {
  source         = "./Modules/ECS/Service"
  ENVIRONMENT    = "${var.ENVIRONMENT_NAME}"
  ALB            = module.ALB_WEBAPP.ALB_ARN
  CLUSTER_ID     = module.ECS_Cluster_WEBAPP.ARN_Cluster
  TF_ID          = module.ECS_TF_WEBAPP.ARN_Task_Definition
  N_TASKS        = 1
  SECURITY_GROUP =  module.SG_ECS.SG_ID
  SUBNETS        = [module.Networking.SubnetPrivates[0],module.Networking.SubnetPrivates[1]]
  TG_ARN         = module.Target_WebAPP.TargetGroup_ARN
  CONTAINER_PORT = 9090
}