#!/usr/bin/env bash
[[ "TRACE" ]] && set -x

kubectl apply -f scripts/rbac.yaml
helm init --service-account tiller
helm version

npm start
