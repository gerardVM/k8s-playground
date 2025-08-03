.DEFAULT_GOAL: start;

## Configuration

CLUSTER_NAME   = local-playground
CLUSTER_CONFIG = scripts/kind-cluster-config.yaml
KUBECONFIG     = tmp/kubeconfig.yaml
CLUSTER        = $(KUBECTL) --kubeconfig $(KUBECONFIG)
TERRAFORM_DIR ?= terraform/k8s

## Quick-start

.PHONY: start
start: cluster-create terraform-init terraform-apply

.PHONY: stop
stop: terraform-destroy cluster-destroy

## Cluster

### Create the cluster using KinD
.PHONY: cluster-create
cluster-create: kind kubectl
# Create the cluster if it does not already exist
	$(KIND) get clusters | grep $(CLUSTER_NAME) || ( \
		$(KIND) create cluster --name $(CLUSTER_NAME) --config $(CLUSTER_CONFIG) --kubeconfig $(KUBECONFIG) && \
		$(CLUSTER) wait --for=condition=ready node --all --timeout=60s && \
		docker exec -it $(CLUSTER_NAME)-control-plane bash -c "apt-get update && apt-get install -y ca-certificates && update-ca-certificates" \
	)

### Destroy the cluster
.PHONY: cluster-destroy
cluster-destroy: kind
# Destroy the cluster
	$(KIND) delete cluster --name $(CLUSTER_NAME)
# Remove the kubeconfig since the cluster no longer exists
	rm $(KUBECONFIG) || true

## Terraform

### Initialize terraform deployment
.PHONY: terraform-init
terraform-init: require-cluster require-kubeconfig terraform
	$(TERRAFORM) -chdir=${TERRAFORM_DIR} init

### Plan the terraform deployment
.PHONY: terraform-plan
terraform-plan: require-cluster require-kubeconfig terraform
	$(TERRAFORM) -chdir=${TERRAFORM_DIR} plan ${TERRAFORM_OPT}

### Apply the terraform deployment
.PHONY: terraform-apply
terraform-apply: require-cluster require-kubeconfig terraform
	$(TERRAFORM) -chdir=${TERRAFORM_DIR} apply ${TERRAFORM_OPT}

### Destroy the terraform deployment
.PHONY: terraform-destroy
terraform-destroy: require-cluster require-kubeconfig terraform
	[ -f ${TERRAFORM_DIR}/terraform.tfstate ] && $(TERRAFORM) -chdir=${TERRAFORM_DIR} destroy ${TERRAFORM_OPT} || true

## Helpers

### Ensure that the cluster exists
.PHONY: require-cluster
require-cluster:
	@$(KIND) get clusters | grep $(CLUSTER_NAME) || (echo "error: cluster is not running. Create the cluster using 'make cluster-create' or 'make start' first." && exit 1)

### Ensure that the kubeconfig exists
.PHONY: require-kubeconfig
require-kubeconfig:
	@[ -f $(KUBECONFIG) ] || (echo "error: kubeconfig is missing." && exit 1)

## Tools

# ===== kind =====
KIND ?= bin/kind
.PHONY: kind
kind: $(KIND)
$(KIND):
	$(SHELL) scripts/install_kind.sh

# ===== kubectl =====
KUBECTL ?= bin/kubectl
.PHONY: kubectl
kubectl: $(KUBECTL)
$(KUBECTL):
	$(SHELL) scripts/install_kubectl.sh

# ===== terraform =====
TERRAFORM ?= bin/terraform
.PHONY: terraform
terraform: $(TERRAFORM)
$(TERRAFORM):
	$(SHELL) scripts/install_terraform.sh
