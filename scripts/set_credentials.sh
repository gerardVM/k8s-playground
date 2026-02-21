#!/usr/bin/env bash
set -euo pipefail

profile="${1:-default}"
directory="${2:-terraform/manifests/credentials}"
aws_file="$directory/aws.env"
sops_file="$directory/sops.yaml"

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

# Create environment files for Kustomize secretGenerator

echo "Creating AWS environment file for Kustomize..."
cat > "$aws_file" << EOF
AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}
AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}
AWS_SESSION_TOKEN=${AWS_SESSION_TOKEN:-}
EOF
echo "✅ Environment file created: $aws_file"

echo "Creating SOPS credentials file for Kustomize..."
cat > "$sops_file" << EOF
aws_access_key_id: ${AWS_ACCESS_KEY_ID}
aws_secret_access_key: ${AWS_SECRET_ACCESS_KEY}
aws_session_token: ${AWS_SESSION_TOKEN:-}
EOF
echo "✅ SOPS credentials file created: $sops_file"