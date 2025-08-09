locals {
  system_config = yamldecode(file("${path.module}/config/system.yaml"))
  apps_config   = yamldecode(file("${path.module}/config/applications.yaml"))

  secrets_path  = "${path.module}/../../k8s/secrets"
  k8s_secrets   = { for f in fileset(local.secrets_path, "*.yaml") : f => "${local.secrets_path}/${f}" }
  k8s_secrets_d = { for k,v in data.sops_file.secret : k => yamldecode(v.raw) }

  helm_releases = { for helm_release in concat(local.system_config.helm_releases, local.apps_config.helm_releases) :
                    "${helm_release.namespace.name}.${helm_release.name}" => helm_release
                      if !try(helm_release.disabled, false)
                  }
}