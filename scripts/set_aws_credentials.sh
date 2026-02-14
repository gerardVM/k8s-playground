#!/usr/bin/env bash
set -euo pipefail

profile="${1:-default}"
manifest="${2:-k8s/terraform/manifests/credentials.yaml}"

# Load credentials from the AWS profile (supports SSO when configured).
eval "$(aws configure export-credentials --profile "$profile" --format env)"

if [[ -z "${AWS_ACCESS_KEY_ID:-}" ]]; then
  echo "error: missing AWS_ACCESS_KEY_ID for profile ${profile}" >&2
  exit 1
fi
if [[ -z "${AWS_SECRET_ACCESS_KEY:-}" ]]; then
  echo "error: missing AWS_SECRET_ACCESS_KEY for profile ${profile}" >&2
  exit 1
fi

sed_in_place() {
  if [[ "$(uname -s)" == "Darwin" ]]; then
    sed -i '' "$@"
  else
    sed -i "$@"
  fi
}

sed_in_place "s|<AWS_ACCESS_KEY_ID>|${AWS_ACCESS_KEY_ID}|g" "$manifest"
sed_in_place "s|<AWS_SECRET_ACCESS_KEY>|${AWS_SECRET_ACCESS_KEY}|g" "$manifest"
if [[ -n "${AWS_SESSION_TOKEN:-}" ]]; then
  sed_in_place "s|<AWS_SESSION_TOKEN>|${AWS_SESSION_TOKEN}|g" "$manifest"
fi
