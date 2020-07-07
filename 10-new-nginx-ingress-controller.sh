# This file explains how to setup the new nginx ingress controller managed by nginxinc
https://docs.nginx.com/nginx-ingress-controller/installation/installation-with-manifests/

# Clone the reposioty
git clone https://github.com/nginxinc/kubernetes-ingress.git
cd kubernetes-ingress/
cd deployments/

# Change the branch name
git checkout v1.7.2

# Create namespace and service account
kubectl apply -f common/ns-and-sa.yaml

# create rbac
kubectl apply -f rbac/rbac.yaml

# apply some common nginx config file
kubectl apply -f common/default-server-secret.yaml
kubectl apply -f common/nginx-config.yaml
kubectl apply -f common/vs-definition.yaml
kubectl apply -f common/vsr-definition.yaml
kubectl apply -f common/ts-definition.yaml
kubectl apply -f common/gc-definition.yaml
kubectl apply -f common/global-configuration.yaml
kubectl apply -f daemon-set/nginx-ingress.yaml


# verify the installation
kubectl get daemonset -o wide --all-namespaces

#Change these two properties

kubectl edit daemonset nginx-ingress -n nginx-ingress

dnsPolicy: Default
hostNetwork: true
