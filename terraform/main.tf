# Flux installation via Helm

resource "helm_release" "flux2" {
  name             = "flux2"
  namespace        = "flux-system"
  create_namespace = true
  repository       = "https://fluxcd-community.github.io/helm-charts"
  chart            = "flux2"
  version          = "2.12.4"
  wait             = true
}


# Kubernetes manifests via Kustomization

data "kustomization_build" "manifests" {
  path = "${path.module}/manifests"
}

resource "kustomization_resource" "manifests" {
  for_each = data.kustomization_build.manifests.ids

  manifest = data.kustomization_build.manifests.manifests[each.value]
}
