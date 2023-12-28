#!/usr/bin/env bash

# select the first base pool node
NODE=$(kubectl get nodes -l cloud.google.com/gke-nodepool=base -o jsonpath='{ .items[0].metadata.name  }')

kubectl label node $NODE workshops.de/special-node=true