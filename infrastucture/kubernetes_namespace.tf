resource "kubernetes_namespace" "this" {
  metadata {
    name = var.k8s_namespace
  }
  
  depends_on = [
    yandex_kubernetes_cluster.k8s-zonal,
    yandex_kubernetes_node_group.this
  ]
}