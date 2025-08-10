resource "kubernetes_namespace" "namespace" {
  for_each = local.namespaces

  metadata {
    name = each.key
  }
}

resource "kubernetes_manifest" "manifest" {
  for_each = local.k8s_manifests

  manifest = yamldecode(file(each.value))

  depends_on = [kubernetes_namespace.namespace]
}

resource "helm_release" "components" {
  for_each = local.helm_releases

  name       = each.value.name
  namespace  = each.value.namespace
  repository = each.value.repository
  chart      = each.value.chart
  version    = each.value.version
  wait       = each.value.wait
  values = try([
    templatefile("${local.values_path}/${each.value.name}.yaml",
      try(each.value.variables, {})
    )
  ], [])

  depends_on = [kubernetes_namespace.namespace]
}
