resource "helm_release" "components" {
  for_each = local.helm_releases

  name             = each.key
  namespace        = each.value.namespace.name
  create_namespace = each.value.namespace.create
  repository       = each.value.repository
  chart            = each.value.chart
  version          = each.value.version
  wait             = each.value.wait
  values           = try([file("${path.module}/values/${each.key}.yaml")], [])
}
