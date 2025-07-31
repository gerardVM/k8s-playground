#!/usr/bin/env bash
set -e

VERSION=0.23.0
echo "installing kind v${VERSION}"

TYPE=$(uname -s|tr '[:upper:]' '[:lower:]')
echo "operating system: ${TYPE}"

case $(uname -m) in
x86_64)
    ARCH=amd64
    ;;
*)
    ARCH=$(uname -m)
    ;;
esac
echo "cpu architecture: ${ARCH}"

mkdir -p bin/
echo "Downloading kind-${TYPE}-${ARCH}"
curl \
  --output bin/kind \
  --location \
  https://github.com/kubernetes-sigs/kind/releases/download/v${VERSION}/kind-${TYPE}-${ARCH}

chmod +x bin/kind
