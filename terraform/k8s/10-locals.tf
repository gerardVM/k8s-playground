locals {
  namespaces    = toset(distinct([for release in local.helm_releases : release.namespace]))
  helm_releases = { for helm_release in yamldecode(file("${path.module}/helm_releases.yaml")).helm_releases :
    "${helm_release.namespace}.${helm_release.name}" => helm_release if !try(helm_release.disabled, false)
  }

  k8s_path  = "${path.module}/../../k8s/terraform"
  k8s_files = {
    for dir in ["values", "manifests", "secrets"] :
      dir => {
        for f in fileset("${local.k8s_path}/${dir}", "*") :
          replace(f, ".yaml", "") => "${local.k8s_path}/${dir}/${f}"
      }
  }
  k8s_secrets_d = { for k, v in data.sops_file.secret : k => yamldecode(v.raw) }
}
