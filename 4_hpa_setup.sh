#!/usr/bin/env bash

set -ev

# Apply resource based horizontal pod autoscaling
kubectl apply -f manifests/application_1_hpa_1/ -R
