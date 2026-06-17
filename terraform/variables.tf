variable "kubeconfig_path" {
  description = "path to kubeconfig"
  type        = string
  default     = "../tmp/kubeconfig.yaml"
}

variable "aws_assume_role" {
  description = "AWS IAM Role ARN for let's encrypt cluster issuer"
  type        = string
  default     = ""
}

variable "cluster_issuer_email" {
  description = "Email address for let's encrypt cluster issuer"
  type        = string
  default     = "info@example.com"
}
