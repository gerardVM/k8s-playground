locals {
  config        = yamldecode(file("${path.module}/config.yaml"))
  helm_releases = { for helm_release in local.config.helm_releases : helm_release.name => helm_release if !try(helm_release.disabled, false) }
}