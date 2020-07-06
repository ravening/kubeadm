# This file mentions the steps required to create a dahboard in kubernetes
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0-beta8/aio/deploy/recommended.yaml

or latest one

kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0/aio/deploy/recommended.yaml

# This will create deployment and dashboard pod also but the container might crash since it cant access the cluster ip
# and you might get timeout error. To fix that you need to add below contents to the dashboard deployment

kubectl get deploy -n kubernetes-dashboard

kubectl edit deploy kubernetes-dashboard -n kubernetes-dashboard


hostNetwork: true
dnsPolicy: Default


# Now you can access dashboard using below link provided that kube proxy is runnin on port 8001

http://localhost:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/


# There are two way to authenticate to login to dashboard. We will talk about token method
# Create a service account
kubectl create serviceaccount dashboard-admin-sa

# Next bind the service account to the admin role
kubectl create clusterrolebinding dashboard-admin-sa --clusterrole=cluster-admin --serviceaccount=default:dashboard-admin-sa


# get the secret created
kubectl get secrets


# Get the token from the secret
kubectl describe secret dashboard-admin-sa-token-kw7vn

# Copy the value present next to the "token" key
