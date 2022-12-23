#!/usr/bin/env sh

source "$(pwd)/secrets"

for file in $(ls ignition-configs/*.bu); do
  envsubst '$CLUSTER_CIDR,$SERVICE_CIDR,$K3S_TOKEN' < "$file" | butane -o "${file%.*}.ign"
done

kubectl create configmap nginx-static-content --from-file ignition-configs -o yaml --dry-run=client | kubectl apply -f -
