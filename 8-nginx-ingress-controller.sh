# This file explains about setting up nginx ingress controller to router traffic from outside world to the pods/services
# The steps mentioned below are only applicable for bare metal setup. So run the below commands only if you are
# running bare metal servers else refer to different components in the wiki
https://github.com/kubernetes/ingress-nginx/blob/master/docs/deploy/index.md

# Create the nginx ingress controller pod by running. Note that this creates pods are service in namespace "ingress-nginx"
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/nginx-0.29.0/deploy/static/mandatory.yaml


# Now create the nginx ingress controller service by running
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/nginx-0.29.0/deploy/static/provider/baremetal/service-nodeport.yaml


# Now check the logs of the nginx ingress controller pod
kubectl logs -f -n ingress-nginx <POD NAME>

# See if the logs display below lines
Creating API client for https://10.96.0.1:443

# If so then nginx ingress controller pod is not running or can't connect to api server.
# In that case you need to change the below line in the deployment of nginx ingress controller

kubectl -n ingress-nginx edit deploy nginx-ingress-controller

dnsPolicy: Default
hostNetwork: true

# Once the pod is in Running state continue further

# Now create the ingress rules to route the traffic from nginx to your service.
# The yaml contianing the required instructions are given below which are stored in ingress-rules.yaml file

apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: helloworld
  namespace: ingress-nginx
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  rules:
  - http:
      paths:
      - path: /hello
        backend:
          serviceName: helloworld
          servicePort: 8080


# A few points to note here
# 1 . It is assumed that a service with name "helloworld" is already created and is exporting the port 8080
# 2 . If the service is not running then create the deployement and create service using
#     kubectl run helloworld --image=docker.io/rakgenius/helloworld:latest -n ingress-nginx
#     kubectl expose deploy helloworld --port=8080  -n ingress-nginx

#Once the deployment and service is setup, apply the nginx ingress controller rules


kubectl apply -f ingress-rules.yaml

# Note that the nginx ingress controller creates a service of type NodePort, so you need to forward port
# from 80 to local port number which is created

# If you dont have port forwarding facility then enable firewall to allow traffic on internal node port
# The above command creates an ingress which can be viewed using
kubectl get ing -n ingress-nginx
NAME              HOSTS   ADDRESS         PORTS   AGE
helloworld        *       10.105.123.73   80      19m

# You can get nging controller service using
kubectl get svc -n ingress-nginx
ingress-nginx   NodePort    10.105.123.73   <none>        80:32372/TCP,443:30907/TCP   37m

# Now your pod can be accessed from outside world using
curl http://<PUBLICIP of MASTER node>/hello

# Note that you dont need to mention the port 80
# If you want to access endpoint using nodeport then run
curl http://<PUBLICIP of MASTER node>/NODEPORT/hello
