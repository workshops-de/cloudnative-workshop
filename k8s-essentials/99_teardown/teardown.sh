#!/bin/bash
set -e

PROJECT_COUNT=$(gcloud projects list --format json | jq .[].projectId | wc -l)
if (( PROJECT_COUNT == 1 )); then
  PROJECT_ID=$(gcloud projects list --format json | jq .[].projectId | tr -d \")
  echo "Project: $PROJECT_ID"
fi
if [[ -z $PROJECT_ID ]]; then
  echo "INPUT: Type PROJECT_ID (studentXX-workshopName):" && read PROJECT_ID
fi

export REGION=europe-west3
export ZONE=europe-west3-a
export CLUSTER_NAME=workshop
export NETWORK_NAME=$CLUSTER_NAME

gcloud config set project $PROJECT_ID
gcloud config set compute/region $REGION
gcloud config set compute/zone $ZONE

gcloud beta container clusters delete $CLUSTER_NAME --quiet
gcloud compute firewall-rules delete $NETWORK_NAME-ingress-gateway --quiet
gcloud compute firewall-rules delete $NETWORK_NAME-ssh --quiet
gcloud compute firewall-rules delete $NETWORK_NAME-nodeport --quiet
gcloud compute networks subnets delete $NETWORK_NAME-subnet --quiet
gcloud compute networks delete $NETWORK_NAME --quiet