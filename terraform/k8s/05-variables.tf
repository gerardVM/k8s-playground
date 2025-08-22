variable "kubeconfig_path" {
  description = "path to kubeconfig"
  type        = string
  default     = "../../tmp/kubeconfig.yaml"
}

variable "email_address" {
  description = "Email address for Let's Encrypt notifications"
  type        = string
}
