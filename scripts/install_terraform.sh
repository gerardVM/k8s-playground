#!/usr/bin/env bash
set -e

VERSION=1.10.3
echo "installing terraform ${VERSION}"

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

tempfile=$(mktemp)

mkdir -p bin/
echo "Downloading terraform ${VERSION} for ${TYPE}-${ARCH}"
curl -L https://releases.hashicorp.com/terraform/${VERSION}/terraform_${VERSION}_${TYPE}_${ARCH}.zip -o $tempfile
unzip -p $tempfile terraform > bin/terraform
rm $tempfile

chmod +x bin/terraform