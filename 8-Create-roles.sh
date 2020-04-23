# If you deploy any pod, by default it doesnt have permission to access the api server.
# If you want your pod to send get requests to api server, it needs to have proper roles
# else you will get perission denied exception
# For that you need to create a service account, role, rolebinding(binds sa to role) and
# cluster role with cluster-admin permission.
# Then pass the serviceaccount name to the deployment of the pod


# Create service account
apiVersion: v1
kind: ServiceAccount
metadata:
  name: configmaps
  
# Create roles

kind: Role
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  namespace: k8
  name: configmaps
rules:
- apiGroups: ["extensions", "apps"]
  resources: ["deployments", "pods", "configmaps", "services", "endpoints"]
  verbs: ["get", "update", "patch", "create", "list"]
  

# Create role binding
kind: RoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: configmaps-role-binding
  namespace: k8
subjects:
- kind: ServiceAccount
  name: configmaps
  namespace: k8
roleRef:
  kind: Role
  name: configmaps
  apiGroup: rbac.authorization.k8s.io


# Create cluster role
kubectl create clusterrolebinding configmaps-clusteradmin --clusterrole=cluster-admin --serviceaccount=k8:configmaps

# or using yaml file
# Create cluster role and clusterrole binding

kind: ClusterRole
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  namespace: k8
  name: configmaps
rules:
- apiGroups: [""] # "" indicates the core API group
  resources: ["deployments", "pods", "configmaps", "services", "endpoints"]
  verbs: ["get", "list", "watch", "update", "patch", "create"]
---
apiVersion: rbac.authorization.k8s.io/v1beta1
kind: ClusterRoleBinding
metadata:
  name: configmaps
subjects:
  - kind: ServiceAccount
    name: sa
    namespace: k8
roleRef:
  kind: ClusterRole
  name: configmaps
  apiGroup: rbac.authorization.k8s.io
