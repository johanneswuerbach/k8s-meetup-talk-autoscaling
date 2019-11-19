#!/usr/bin/env bash

set -ev

# Inspect resource based horizontal vertical pod autoscaling
kubectl describe vpa/rabbitmq
