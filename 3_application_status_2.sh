#!/usr/bin/env bash

set -ev

# Validate application status

kubectl get pods

kubectl get service http-api -o json | jq -r .status.loadBalancer.ingress[0].hostname

kubectl port-forward rabbitmq-0 15672:15672
