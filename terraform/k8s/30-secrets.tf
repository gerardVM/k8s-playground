data "sops_file" "secret" {
  for_each = local.k8s_files.secrets

  source_file = each.value
}

resource "kubernetes_secret" "secrets" {
  for_each = local.k8s_secrets_d

  metadata {
    name      = each.value.metadata.name
    namespace = each.value.metadata.namespace
  }

  data = each.value.data

  depends_on = [kubernetes_namespace.namespace]
}
