# Temporary patch during implementation of a non-persistent credentials alternative

resource "aws_iam_user" "external_dns" {
  name = "external-dns"
  path = "/k8s-playground/"

  tags = {
    scope = "k8s-playground"
  }
}

data "aws_iam_policy_document" "external_dns" {
  statement {
    sid       = "AllowRoute53"
    effect    = "Allow"
    actions   = ["route53:ChangeResourceRecordSets"]
    resources = ["arn:aws:route53:::hostedzone/*"]
  }
  statement {
    sid       = "AllowListRoute53Zones"
    effect    = "Allow"
    actions   = ["route53:ListHostedZones", "route53:ListResourceRecordSets", "route53:ListTagsForResources"]
    resources = ["*"]
  }
}

resource "aws_iam_user_policy" "external_dns" {
  name   = "external-dns"
  user   = aws_iam_user.external_dns.name
  policy = data.aws_iam_policy_document.external_dns.json
}
