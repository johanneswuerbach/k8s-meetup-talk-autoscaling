#!/usr/bin/env bash

set -ev

# Apply application manifests
kubectl apply -f manifests/application/ -R
