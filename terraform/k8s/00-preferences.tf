terraform {
  required_version = ">= 1.10.3"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.35.1"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 3.0.2"
    }
    sops = {
      source  = "carlpett/sops"
      version = "~> 1.0"
    }
  }
}

provider "kubernetes" {
  config_path = var.kubeconfig_path
}

provider "helm" {
  kubernetes = {
    config_path = var.kubeconfig_path
  }
}

provider "sops" {}

variable "kubeconfig_path" {
  description = "path to kubeconfig"
  type        = string
  default     = "../../tmp/kubeconfig.yaml"
}
