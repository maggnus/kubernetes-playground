# Makefile for managing Kind Kubernetes cluster

KIND_CLUSTER_NAME = kubernetes-playground
KIND_CONFIG_FILE = kind-config.yaml

.PHONY: up down

up:
	# Kind cluster
	kind create cluster --name $(KIND_CLUSTER_NAME) --config $(KIND_CONFIG_FILE) | true
	# Istio
	istioctl operator init
	istioctl install -y
	kubectl label namespace default istio-injection=enabled | true
	# Addons
	kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.22/samples/addons/grafana.yaml
	kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.22/samples/addons/prometheus.yaml
	kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.22/samples/addons/jaeger.yaml
	kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.22/samples/addons/loki.yaml
	kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.22/samples/addons/kiali.yaml

down:
	@kind delete cluster --name $(KIND_CLUSTER_NAME)

down_all:
	@kind get clusters | xargs -I {} kind delete cluster --name {}

ls:
	@kind get clusters

context:
	@kubectl config current-context

metrics-server:
	helm repo add metrics-server https://kubernetes-sigs.github.io/metrics-server/
	helm install -n kube-system metrics-server metrics-server/metrics-server --set args={--kubelet-insecure-tls} | true

prometheus-adapter-up:
	helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
	helm install prometheus-adapter prometheus-community/prometheus-adapter --values prometheus-adapter/adapter-values.yaml --wait | true
	kubectl apply -f ./prometheus-adapter/sample-app

prometheus-adapter-down:
	kubectl delete -f ./prometheus-adapter/sample-app
	helm uninstall prometheus-adapter | true
