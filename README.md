## Initial setup
Export de env variables:

```
DIGITALOCEAN_TOKEN=xxxxx
SPACES_ACCESS_TOKEN=xxx
SPACES_SECRET_KEY=xxx
```


Create the cluster
```
tf init \
 -backend-config="access_key=$SPACES_ACCESS_TOKEN" \
 -backend-config="secret_key=$SPACES_SECRET_KEY"
```

```
tf plan
```


Authenticate using your token to get credentials store in kubeconfig:

First:
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

