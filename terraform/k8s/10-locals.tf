locals {
  system_config = yamldecode(file("${path.module}/config/system.yaml"))
  apps_config   = yamldecode(file("${path.module}/config/applications.yaml"))
  helm_releases = { for helm_release in concat(local.system_config.helm_releases, local.apps_config.helm_releases) :
                    "${helm_release.namespace.name}.${helm_release.name}" => helm_release
                      if !try(helm_release.disabled, false)
                  }
} 