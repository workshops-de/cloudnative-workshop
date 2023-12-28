#!/usr/bin/env bash

# select the first base pool node
NODE=$(kubectl get nodes -l workshops.de/special-node=true -o jsonpath='{ .items[0].metadata.name  }')

kubectl label node $NODE workshops.de/special-node-