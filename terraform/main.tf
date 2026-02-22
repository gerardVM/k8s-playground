# Flux installation via Helm

resource "helm_release" "flux2" {
  name             = "flux2"
  namespace        = "flux-system"
  create_namespace = true
  repository       = "https://fluxcd-community.github.io/helm-charts"
  chart            = "flux2"
  version          = "2.13.0"
  wait             = true
}


# Kubernetes manifests via Kustomization

data "kustomization_overlay" "manifests" {  
  resources = ["${path.module}/manifests"]

  config_map_generator {
    name      = "environment"
    namespace = "flux-system"
    literals  = [
      "role=${var.aws_assume_role}",
      "email=${var.cluster_issuer_email}"
    ]

    options {
      disable_name_suffix_hash = true
    }
  }
}

resource "kustomization_resource" "manifests" {
  for_each = data.kustomization_overlay.manifests.ids

  manifest = data.kustomization_overlay.manifests.manifests[each.value]

  depends_on = [helm_release.flux2]
}
