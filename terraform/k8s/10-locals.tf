locals {
  namespaces    = toset(distinct([for release in local.helm_releases : release.namespace]))
  helm_releases = { for helm_release in yamldecode(file("${path.module}/helm_releases.yaml")).helm_releases :
    "${helm_release.namespace}.${helm_release.name}" => helm_release if !try(helm_release.disabled, false)
  }

  values_path   = "${local.k8s_path}/values"
  k8s_path      = "${path.module}/../../k8s/terraform"
  k8s_manifests = { for f in fileset("${local.k8s_path}/manifests", "*.yaml") : f => "${local.k8s_path}/manifests/${f}" }
  k8s_secrets   = { for f in fileset("${local.k8s_path}/secrets", "*.yaml") : f => "${local.k8s_path}/secrets/${f}" }
  k8s_secrets_d = { for k, v in data.sops_file.secret : k => yamldecode(v.raw) }
}
