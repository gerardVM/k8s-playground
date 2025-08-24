# Namespaces (from Kubernetes manifests)

resource "kubernetes_manifest" "namespace" {
  for_each = local.k8s_resources.namespaces

  manifest = each.value
}


# Kubernetes manifests

resource "kubernetes_manifest" "manifest" {
  for_each = local.k8s_resources.manifests

  manifest = each.value

  depends_on = [kubernetes_secret.secrets]
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


# Flux synchronization

resource "helm_release" "flux2_sync" {
  name       = "flux-system"
  namespace  = "flux-system"
  repository = "https://fluxcd-community.github.io/helm-charts"
  chart      = "flux2-sync"
  version    = "1.8.2"
  wait       = true
  values     = try([
    file(local.k8s_files.values["flux2-sync"])
  ], [])

  depends_on = [helm_release.components]
}
