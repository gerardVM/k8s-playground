locals {
  system_config = yamldecode(file("${path.module}/config/system.yaml"))
  apps_config   = yamldecode(file("${path.module}/config/applications.yaml"))

  namespaces    = toset(distinct([for release in local.helm_releases : release.namespace]))
  manifests     = { for f in fileset("${path.module}/../../k8s/manifests", "*.yaml") : f => "${path.module}/../../k8s/manifests/${f}" }
  k8s_secrets   = { for f in fileset("${path.module}/../../k8s/secrets", "*.yaml") : f => "${path.module}/../../k8s/secrets/${f}" }
  k8s_secrets_d = { for k, v in data.sops_file.secret : k => yamldecode(v.raw) }
  helm_releases = { for helm_release in concat(local.system_config.helm_releases, local.apps_config.helm_releases) :
    "${helm_release.namespace}.${helm_release.name}" => helm_release if !try(helm_release.disabled, false)
  }
}
