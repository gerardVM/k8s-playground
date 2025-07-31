variable "kubeconfig_path" {
  description = "path to kubeconfig"
  type        = string
  default     = "../tmp/kubeconfig.yaml"
}

variable "traefik_web_nodeport" {
  description = "nodeport to expose traefik web (http) ingress"
  type        = number
  default     = 30000
}
