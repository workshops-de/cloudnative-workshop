#!/usr/bin/env bash

COUNT=${1}

for i in $(seq 1 ${COUNT}); do
echo "
apiVersion: v1
kind: PersistentVolume
metadata:
  name: my-pv-${i}
  labels:
    type: my-pv
spec:
  storageClassName: ""
  capacity:
    storage: 1Gi
  accessModes:
    - ReadWriteOnce
  persistentVolumeReclaimPolicy: Delete
  hostPath:
    path: /tmp/my-pv-${i}" | kubectl create -f -
done