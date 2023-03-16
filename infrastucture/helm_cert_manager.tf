resource "helm_release" "cert_manager" {
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  version    = "v1.11.0"
  namespace  = "cert-manager"
  create_namespace = true
  
  set {
    name  = "installCRDs"
    value = true
  }
  
  depends_on = [
    yandex_kubernetes_cluster.k8s-zonal,
    yandex_kubernetes_node_group.this,
    helm_release.ingress_nginx
  ]
}

resource "kubectl_manifest" "cluster_issuer_prod" {
  depends_on = [ 
    helm_release.cert_manager
  ]
  yaml_body = <<YAML
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-prod
  namespace: cert-manager
spec:
  acme:
    server: https://acme-v02.api.letsencrypt.org/directory
    email: s045724@yandex.ru
    privateKeySecretRef:
      name: letsencrypt-prod
    solvers:
    - http01:
        ingress:
          class: nginx
YAML
}

resource "kubectl_manifest" "cluster_issuer_staging" {
  depends_on = [ 
    helm_release.cert_manager
  ]
  yaml_body = <<YAML
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-staging
  namespace: cert-manager
spec:
  acme:
    server: https://acme-staging-v02.api.letsencrypt.org/directory
    email: s045724@yandex.ru
    privateKeySecretRef:
      name: letsencrypt-staging
    solvers:
      - http01:
          ingress:
            class: nginx
YAML
}