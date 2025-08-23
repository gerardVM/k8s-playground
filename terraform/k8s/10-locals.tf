locals {
  k8s_variables = {
    ACME_EMAIL_ADDRESS = var.email_address
  }

  helm_namespaces = toset(distinct([for release in local.helm_releases : release.namespace]))
  helm_releases   = { for helm_release in yamldecode(file("${path.module}/helm_releases.yaml")).helm_releases :
    "${helm_release.namespace}.${helm_release.name}" => helm_release if !try(helm_release.disabled, false)
  }

  k8s_path = "${path.module}/../../k8s/terraform"

  k8s_files = {
    for dir in ["values", "manifests", "namespaces", "secrets"] :
      dir => {
        for f in fileset("${local.k8s_path}/${dir}",  "**/*.yaml") :
          replace(f, ".yaml", "") => "${local.k8s_path}/${dir}/${f}"
      }
  }

  k8s_resources = {
    for dir in ["manifests", "namespaces"] :
      dir => {
        for m in flatten([
          for file_name, file_path in local.k8s_files[dir] : [
            for resource in provider::kubernetes::manifest_decode_multi(
              templatefile(file_path, local.k8s_variables)
            ) : {
              key   = "${file_name}-${resource.kind}"
              value = resource
            }
          ]
        ]) : m.key => m.value
      }
  }

  k8s_secrets_d = { for k, v in data.sops_file.secret : k => yamldecode(v.raw) }
}
