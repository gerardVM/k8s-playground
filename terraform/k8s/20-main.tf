# Namespaces (from Kubernetes manifests)

resource "kubernetes_manifest" "namespace" {
  for_each = local.k8s_resources.namespaces

  manifest = yamldecode(each.value)
}


# Kubernetes manifests

resource "kubernetes_manifest" "manifest" {
  for_each = local.k8s_resources.manifests

  manifest = yamldecode(each.value)

  depends_on = [helm_release.components]
}


# Namespaces (from Helm releases)

resource "kubernetes_namespace" "namespace" {
  for_each = local.helm_namespaces

  metadata {
    name = each.key
  }
}


# Helm releases

resource "helm_release" "components" {
  for_each = local.helm_releases

  name       = each.value.name
  namespace  = each.value.namespace
  repository = each.value.repository
  chart      = each.value.chart
  version    = each.value.version
  wait       = each.value.wait
  set        = try(each.value.set, [])
  values = try([
    templatefile(local.k8s_files.values[each.value.name],
      try(each.value.variables, {})
    )
  ], [])

  depends_on = [kubernetes_secret.secrets]
}
