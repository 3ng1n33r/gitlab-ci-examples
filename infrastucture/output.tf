locals {
  kubeconfig = <<KUBECONFIG
apiVersion: v1
clusters:
- cluster:
    server: ${data.yandex_kubernetes_cluster.this.master[0].external_v4_endpoint}
    certificate-authority-data: ${base64encode(data.yandex_kubernetes_cluster.this.master[0].cluster_ca_certificate)}
  name: kubernetes
contexts:
- context:
    cluster: kubernetes
    user: yc
  name: ycmk8s
current-context: ycmk8s
users:
- name: yc
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1beta1
      command: yc
      args:
      - k8s
      - create-token
KUBECONFIG
}

output "kubeconfig" {
  value = "${local.kubeconfig}"
}
