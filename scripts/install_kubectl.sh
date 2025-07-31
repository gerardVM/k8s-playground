#!/usr/bin/env bash
set -e

VERSION=1.30.1
echo "installing kubectl ${VERSION}"

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
echo "Downloading kubectl ${VERSION} for ${TYPE}-${ARCH}"
curl -L -o bin/kubectl https://dl.k8s.io/release/v${VERSION}/bin/${TYPE}/${ARCH}/kubectl


chmod +x bin/kubectl