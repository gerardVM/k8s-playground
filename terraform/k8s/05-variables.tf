variable "kubeconfig_path" {
  description = "path to kubeconfig"
  type        = string
  default     = "../../tmp/kubeconfig.yaml"
}

variable "acme_email_address" {
  description = "Email address for Let's Encrypt notifications"
  type        = string
  default     = "example@example.com"
}
