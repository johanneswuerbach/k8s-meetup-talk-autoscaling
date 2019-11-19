#!/usr/bin/env bash

set -ev

# Apply resource based horizontal vertical pod autoscaling
kubectl apply -f manifests/application_2_vpa/ -R
