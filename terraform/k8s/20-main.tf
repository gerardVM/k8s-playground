data "sops_file" "secret" {
  for_each = local.k8s_secrets

  source_file = each.value
}

resource "kubernetes_secret" "secrets" {
  for_each = data.sops_file.secret

  metadata {
    name      = yamldecode(each.value.raw).metadata.name
    namespace = yamldecode(each.value.raw).metadata.namespace
  }

  data = yamldecode(each.value.raw).data
}

resource "helm_release" "components" {
  for_each = local.helm_releases

  name             = each.value.name
  namespace        = each.value.namespace.name
  create_namespace = each.value.namespace.create
  repository       = each.value.repository
  chart            = each.value.chart
  version          = each.value.version
  wait             = each.value.wait
  values           = try([
    templatefile("${path.module}/values/${each.value.name}.yaml",
      try(each.value.variables, {})
    )
  ], [])
}
