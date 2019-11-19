#!/usr/bin/env bash

set -ev

# Setup cluster-autoscaler
kubectl apply -R -f manifests/_prepare/cluster-autoscaler

# Setup vertical-pod-autoscaler
kubectl apply -R -f manifests/_prepare/vertical-pod-autoscaler

# Setup prometheus metrics pipeline
if [ ! -d "manifests/_prepare/kube-prometheus" ]; then
  git clone https://github.com/coreos/kube-prometheus.git manifests/_prepare/kube-prometheus
fi

pushd manifests/_prepare/kube-prometheus
  kubectl apply -f manifests/setup

  until kubectl get servicemonitors --all-namespaces ; do date; sleep 1; echo ""; done

  kubectl apply -f manifests/
popd

# Setup custom metrics
kubectl apply -R -f manifests/_prepare/custom-metrics-api

# Restart k8s-prometheus-adapter to reload custom metrics configmap
kubectl delete pod -n monitoring -l name=prometheus-adapter
