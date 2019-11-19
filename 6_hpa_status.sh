#!/usr/bin/env bash

set -ev

# Inspect custom metrics based horizontal pod autoscaling status
kubectl describe horizontalpodautoscaler.autoscaling/consumer
