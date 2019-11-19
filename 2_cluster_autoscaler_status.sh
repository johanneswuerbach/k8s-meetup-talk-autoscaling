#!/usr/bin/env bash

set -ev

# Visual cluster-autoscaler status
kubectl -n kube-system describe configmap cluster-autoscaler-status
