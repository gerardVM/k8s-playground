# Kubernetes Playground

## Description

This repository contains a Kubernetes playground for testing and experimenting with Kubernetes resources and configurations. It provides a local Kubernetes cluster using KinD (Kubernetes in Docker).

## Usage

Just run `make start` to create the cluster and deploy the resources defined in the Terraform configuration.

Run `export KUBECONFIG=tmp/kubeconfig.yaml` to set the kubeconfig for kubectl commands.

Run `make stop` to delete the cluster and clean up resources.

### Secrets Management

The secrets placed in the `k8s/terraform/secrets` directory need to be encrypted using SOPS. To use plain text secrets, you can place them in the `k8s/terraform/manifests` directory. Make sure you delete the encrypted secrets files before starting.
