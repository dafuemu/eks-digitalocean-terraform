# main.tf
resource "digitalocean_kubernetes_cluster" "k8s-cluster" {
  name   = "k8s-cluster"
  region = "fra1"
  # Grab the latest version slug from `doctl kubernetes options versions`
  version = "1.21.9-do.0"
  tags = ["k8s-cluster"]

node_pool {
    name       = "autoscale-worker-pool"
    size       = "s-2vcpu-4gb"
    auto_scale = true
    min_nodes  = 1
    max_nodes  = 5
  }
}