resource "helm_release" "traefik" {
  name              = "traefik"
  namespace         = "traefik"
  create_namespace  = true
  repository        = "https://helm.traefik.io/traefik"
  chart             = "traefik"
  version           = "v35.4.0"
  wait              = true
  values            = [
    templatefile(abspath("${path.module}/helm/traefik.yaml"), {
      web_node_port       = var.traefik_web_nodeport
    })
  ]
}