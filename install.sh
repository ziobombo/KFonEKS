#! /bin/bash

eksctl create cluster -f /config/cluster.yaml
cd /config/AWS_CLUSTER_NAME/
kfctl apply -V -f kfctl_aws.yaml
kubectl -n AWS_CLUSTER_NAME get all
kubectl get ingress -n istio-system
