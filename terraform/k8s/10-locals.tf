locals {
  config        = yamldecode(file("${path.module}/config.yaml"))
  helm_releases = { for name, values in local.config.helm_releases : name => values if !try(values.disabled, false) }
}