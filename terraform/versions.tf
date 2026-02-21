terraform {
  required_version = ">= 1.10.3"

  required_providers {
    kustomization = {
      source = "kbst/kustomization"
      version = "0.9.7"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 3.0.2"
    }
  }
}

provider "helm" {
  kubernetes = {
    config_path = var.kubeconfig_path
  }
}

provider "kustomization" {
  kubeconfig_path = var.kubeconfig_path
}
