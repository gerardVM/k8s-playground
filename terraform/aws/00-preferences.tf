provider "aws" {
  region = var.aws_region
  assume_role {
    role_arn     = "arn:aws:iam::${var.aws_account_id}:role/${var.aws_role}"
    session_name = "k8s-playground"
  }
}

terraform {
  required_version = ">= 1.10.3"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0"
    }
  }
}

variable "aws_region" {
  type    = string
}

variable "aws_role" {
  type    = string
}

variable "aws_account_id" {
  type    = string
}
