#!/usr/bin/env bash

set -ev


# Remove kube-prometheus clone
mv manifests/_prepare/kube-prometheus/manifests manifests/kpm
rm -rf manifests/_prepare/kube-prometheus

# Destroy manifests
kubectl delete --ignore-not-found -R -f manifests/

# Remove kube-prometheus manifests
rm -rf manifests/kpm

# Destroy PVC
kubectl delete pvc --all

# Destroy EKS cluster
eksctl delete cluster -w -f cluster/cluster.yaml
