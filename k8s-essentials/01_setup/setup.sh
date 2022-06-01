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

# enable services
gcloud services enable compute.googleapis.com
gcloud services enable container.googleapis.com

# Network
has_network=$(gcloud compute networks list --format="value(name)" --filter="name=$NETWORK_NAME" --project=$PROJECT_ID)
if [ -z "$has_network" ]
then
  gcloud compute networks create $NETWORK_NAME --project=$PROJECT_ID \
    --subnet-mode=custom --mtu=1460 --bgp-routing-mode=regional
fi

# Subnet
has_subnet=$(gcloud compute networks subnets list --format="value(name)" --filter="name=$NETWORK_NAME-subnet" --project=$PROJECT_ID)
if [ -z "$has_subnet" ]
then
  gcloud compute networks subnets create $NETWORK_NAME-subnet --project=$PROJECT_ID \
    --range=10.0.0.0/24 --stack-type=IPV4_ONLY --network=$NETWORK_NAME --region=$REGION
fi

# Cluster
has_cluster=`gcloud beta container clusters list --filter="name=$CLUSTER_NAME" --format="value(name)" --project=$PROJECT_ID`
if [ -z "$has_cluster" ]
then
  gcloud beta container --project $PROJECT_ID clusters create $CLUSTER_NAME \
    --zone $ZONE --cluster-version "1.23.6-gke.1500" \
    --no-enable-basic-auth  --release-channel "None" \
    --machine-type "n2-standard-4" --image-type "COS_CONTAINERD" \
    --disk-type "pd-standard" --disk-size "100" \
    --metadata disable-legacy-endpoints=true \
    --scopes "https://www.googleapis.com/auth/devstorage.read_only","https://www.googleapis.com/auth/logging.write","https://www.googleapis.com/auth/monitoring","https://www.googleapis.com/auth/servicecontrol","https://www.googleapis.com/auth/service.management.readonly","https://www.googleapis.com/auth/trace.append" \
    --max-pods-per-node "110" --num-nodes "2" --enable-ip-alias \
    --network "projects/$PROJECT_ID/global/networks/$NETWORK_NAME" \
    --subnetwork "projects/$PROJECT_ID/regions/$REGION/subnetworks/$NETWORK_NAME-subnet" \
    --no-enable-intra-node-visibility --default-max-pods-per-node "110" --no-enable-master-authorized-networks \
    --addons HorizontalPodAutoscaling,HttpLoadBalancing,GcePersistentDiskCsiDriver \
    --no-enable-autoupgrade --enable-autorepair --max-surge-upgrade 1 --max-unavailable-upgrade 0 \
    --no-enable-shielded-nodes --node-locations "$ZONE"
fi

# Firewall Ingress
has_firewall_ingress=`gcloud compute firewall-rules list --filter="$NETWORK_NAME-ingress-gateway" --format="value(name)" --project=$PROJECT_ID`

if [ -z "$has_firewall_ingress" ]
then
  gcloud compute firewall-rules create $NETWORK_NAME-ingress-gateway \
    --network $NETWORK_NAME \
    --direction=INGRESS \
    --action=ALLOW \
    --source-ranges=0.0.0.0/0 \
    --rules=tcp:80,tcp:8080,tcp:443
fi

# Firewall SSH
has_firewall_ssh=`gcloud compute firewall-rules list --filter="$NETWORK_NAME-ssh" --format="value(name)" --project=$PROJECT_ID`

if [ -z "$has_firewall_ssh" ]
then
  gcloud compute firewall-rules create $NETWORK_NAME-ssh \
    --direction=INGRESS \
    --network=$NETWORK_NAME \
    --action=ALLOW \
    --source-ranges=0.0.0.0/0 \
    --rules=tcp:22
fi

# Firewall NodePorts
has_firewall_nodeport=`gcloud compute firewall-rules list --filter="$NETWORK_NAME-nodeport" --format="value(name)" --project=$PROJECT_ID`

if [ -z "$has_firewall_nodeport" ]
then
  gcloud compute firewall-rules create $NETWORK_NAME-nodeport \
    --direction=INGRESS \
    --network=$NETWORK_NAME \
    --action=ALLOW \
    --source-ranges=0.0.0.0/0 \
    --rules=tcp:30000-32767
fi

# connect to cluster
gcloud container clusters get-credentials $CLUSTER_NAME
echo 'source <(kubectl completion bash)' >> ~/.bashrc && source ~/.bashrc