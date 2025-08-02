locals {
  config        = yamldecode(file("${path.module}/config.yaml"))
  helm_releases = local.config.helm_releases
}