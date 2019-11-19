#!/usr/bin/env bash

set -ev

# Create a kubernetes cluster
eksctl create cluster -f cluster/cluster.yaml --auto-kubeconfig
