
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  alias  = "secondary"
  region = var.sec_region
}
provider "aws" {
  alias  = "primary"
  region = var.pri_region
}