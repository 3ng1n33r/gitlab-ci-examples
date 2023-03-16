resource "helm_release" "ingress_nginx" {
  name       = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"

  namespace        = "ingress-nginx"
  create_namespace = true

  depends_on = [
    yandex_kubernetes_cluster.k8s-zonal,
    yandex_kubernetes_node_group.this
  ]
}
