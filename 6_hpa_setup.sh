#!/usr/bin/env bash

set -ev

# Apply custom metrics based horizontal pod autoscaling
kubectl apply -f manifests/application_3_hpa_2/ -R
