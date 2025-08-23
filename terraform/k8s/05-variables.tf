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

variable "flux" {
  description = "Flux configuration"
  type = object({
    git_repository_url      = string
    git_repository_branch   = string
    git_repository_interval = string
    kustomize_path          = string
  })
  default = {
    git_repository_url      = "https://github.com/gerardvm/k8s-playground.git"
    git_repository_branch   = "main"
    git_repository_interval = "1m"
    kustomize_path          = "k8s/flux"
  }
}
