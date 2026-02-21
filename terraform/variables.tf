variable "kubeconfig_path" {
  description = "path to kubeconfig"
  type        = string
  default     = "../tmp/kubeconfig.yaml"
}

variable "cluster_issuer_role" {
  description = "AWS IAM Role ARN for let's encrypt cluster issuer"
  type        = string
}

variable "cluster_issuer_email" {
  description = "Email address for let's encrypt cluster issuer"
  type        = string
}

