#!/usr/bin/env bash

set -ev

# Validate application status

make open-endpoint

sleep 3

kubectl logs -l app=http-api
