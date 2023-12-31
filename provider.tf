terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.59.0"
    }
  }
}

provider "aws" {
  region = var.var_region
}
