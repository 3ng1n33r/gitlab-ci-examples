resource "kubectl_manifest" "cicd_gitlab_registry" {
  depends_on = [ 
    kubernetes_namespace.this,
  ]
  yaml_body = <<YAML
apiVersion: v1
data:
  .dockerconfigjson: eyJhdXRocyI6eyJyZWdpc3RyeS5naXRsYWIuY29tIjp7InVzZXJuYW1lIjoiZ2l0bGFiK2RlcGxveS10b2tlbi0xODU1NjE2IiwicGFzc3dvcmQiOiJxa2NYd0VYTDFGZXk3eDQ5blE2eSIsImF1dGgiOiJaMmwwYkdGaUsyUmxjR3h2ZVMxMGIydGxiaTB4T0RVMU5qRTJPbkZyWTFoM1JWaE1NVVpsZVRkNE5EbHVVVFo1In19fQ==
kind: Secret
metadata:
  name: cicd-gitlab-registry
  namespace: flask-app-production
type: kubernetes.io/dockerconfigjson
YAML
}