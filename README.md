## Niveles de maduracion

• Nivel 0: Bash & npm scripts, Jenkins
• Nivel 1: CI/CD pipelines, IaC, Contenerizaci n
• Nivel 2: Cloud Monitoring & DevSecOps
• Nivel 3: Service Mesh, Operadores

## Initial setup


Export de env variables:

```
DIGITALOCEAN_TOKEN=xxxxx
SPACES_ACCESS_TOKEN=xxx
SPACES_SECRET_KEY=xxx
```


Create the cluster
```
terraform init \
 -backend-config="access_key=$SPACES_ACCESS_TOKEN" \
 -backend-config="secret_key=$SPACES_SECRET_KEY"
```

```
tf plan
```

```
terraform apply
```

Authenticate using your token to get credentials store in kubeconfig:

```
doctl auth init (you will be asked to introduced your token)
touch kubeconfig
export KUBECONFIG=$PWD/kubeconfig
doctl kubernetes cluster kubeconfig save k8s-cluster
```

Testing the connection and cluster setup:
```
kubectl get pods -A
```

Follow tutorial to deploy an app on k8s and make it public:
https://www.digitalocean.com/community/meetup_kits/getting-started-with-containers-and-kubernetes-a-digitalocean-workshop-kit#:~:text=into%20your%20cluster.-,Step%202%20%E2%80%94%20Deploying%20the%20Flask%20App%20on%20Kubernetes,-The%20app%20and

https://kubernetes.io/docs/reference/kubectl/cheatsheet/

Similarly, to delete a Namespace, use delete namespace:

Warning: Deleting a Namespace will delete everything in the Namespace, including running Deployments, Pods, and other workloads. Only run this command if you’re sure you’d like to kill whatever’s running in the Namespace or if you’re deleting an empty Namespace.


Adding the Nginx Ingress controller, documantation (here|https://kubernetes.github.io/ingress-nginx/) and the instalation guide (here|https://kubernetes.github.io/ingress-nginx/deploy/#digital-ocean)
```
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.1.1/deploy/static/provider/do/deploy.yaml
kubectl get services -n ingress-nginx
```
How to configurevthe ingress (here|https://kubernetes.github.io/ingress-nginx/user-guide/basic-usage/). "Please note that the ingress resource should be placed inside the same namespace of the backend resource."

Getting the expernal IP:
```
kubectl get services -n ingress-nginx
```

Things to add:

- Kubernetes dahsboard (https://github.com/kubernetes/dashboard)
- Prometheous stack (https://github.com/prometheus-operator/kube-prometheus)
- Elastic stack (https://www.elastic.co/blog/introducing-elastic-cloud-on-kubernetes-the-elasticsearch-operator-and-beyond | )
- Database (https://operatorhub.io/operator/postgres-operator | https://blog.flant.com/comparing-kubernetes-operators-for-postgresql/)
- infrastructure diagram
- Docuemntation

# Kubernetes Dashboard

To install kubernetes dashboard run the following command:
```
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.5.0/aio/deploy/recommended.yaml
```
Getting access to the Dashboard:

We need a token, a user will be created to access this new service:
https://github.com/kubernetes/dashboard/blob/master/docs/user/access-control/creating-sample-user.md

## Creating a Service Account
```
apiVersion: v1
kind: ServiceAccount
metadata:
  name: admin-user
  namespace: kubernetes-dashboard
```
## Creating a ClusterRoleBinding
In most cases after provisioning the cluster using kops, kubeadm or any other popular tool, the ClusterRole cluster-admin already exists in the cluster. We can use it and create only a ClusterRoleBinding for our ServiceAccount. If it does not exist then you need to create this role first and grant required privileges manually.

```
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: admin-user
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: admin-user
  namespace: kubernetes-dashboard
```
## Getting a Bearer Token

Now we need to find the token we can use to log in. Execute the following command:
```
kubectl -n kubernetes-dashboard get secret $(kubectl -n kubernetes-dashboard get sa/admin-user -o jsonpath="{.secrets[0].name}") -o go-template="{{.data.token | base64decode}}"
```

```
kubectl proxy
http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/
```

Clean up actions and links with more info about  authentication & authorization:

https://github.com/kubernetes/dashboard/blob/master/docs/user/access-control/creating-sample-user.md#clean-up-and-next-steps




