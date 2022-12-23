#!/usr/bin/env sh

source "$(pwd)/secrets"

for file in $(ls ignition-configs/*.bu); do
  envsubst "$(printf '${%s} ' $(env | cut -d'=' -f1))" < "$file" | butane -o "${file%.*}.ign"
done

kubectl create configmap nginx-static-content --from-file ignition-configs -o yaml --dry-run=client | kubectl apply -f -
