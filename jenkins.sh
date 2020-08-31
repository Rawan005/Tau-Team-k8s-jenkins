#!/bin/bash
	    k3d cluster create Tauteam-Cluster \
	    -p 80:80@loadbalancer \
	    -p 443:443@loadbalancer \
	    -p 30000-32767:30000-32767@server[0] \
	    -v /etc/machine-id:/etc/machine-id:ro \
	    -v /var/log/journal:/var/log/journal:ro \
	    -v /var/run/docker.sock:/var/run/docker.sock \
	    --agents 2
kubectl apply -f jenkins.namespace.yaml -f jenkins.helm.yaml -f ingress.yaml
kubectl  label node k3d-tauteam-cluster-agent-0 type=worker-0
kubectl  label node k3d-tauteam-cluster-agent-1 type=worker-1
kubectl  label node k3d-tauteam-cluster-server-0 type=master
WAIT=90
echo "Sleeping for $WAIT"
sleep $WAIT
kubectl create -n jenkins clusterrolebinding jenkins-account --clusterrole=cluster-admin --serviceaccount=jenkins:jenkins
kubectl create -n elf clusterrolebinding jenkins --clusterrole=cluster-admin --serviceaccount=jenkins:default
kubectl create -n monitor  clusterrolebinding jenkins2 --clusterrole=cluster-admin --serviceaccount=jenkins:default

echo "Making progress"
. query.sh
