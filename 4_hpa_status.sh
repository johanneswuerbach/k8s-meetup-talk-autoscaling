#!/usr/bin/env bash

set -ev

# Inspect resource based horizontal pod autoscaling status
kubectl describe horizontalpodautoscaler.autoscaling/http-api
