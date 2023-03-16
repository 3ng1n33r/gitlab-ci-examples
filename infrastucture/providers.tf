terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.3"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.1.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.14.0"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  token     = "${var.YC_TOKEN}"
  cloud_id  = "${var.YC_CLOUD_ID}" 
  folder_id = "${var.YC_FOLDER_ID}"
}

provider "helm" {
  kubernetes {
    host = "${data.yandex_kubernetes_cluster.this.master[0].external_v4_endpoint}"
    cluster_ca_certificate = "${data.yandex_kubernetes_cluster.this.master[0].cluster_ca_certificate}"
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command = "yc"
      args = [
        "managed-kubernetes",
        "create-token",
        "--cloud-id", "${var.YC_CLOUD_ID}",
        "--folder-id", "${var.YC_FOLDER_ID}",
        "--token", "${var.YC_TOKEN}",
      ]
    }
  }
}

provider "kubernetes" {
  host = "${data.yandex_kubernetes_cluster.this.master[0].external_v4_endpoint}"
  cluster_ca_certificate = "${data.yandex_kubernetes_cluster.this.master[0].cluster_ca_certificate}"
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command = "yc"
    args = [
      "managed-kubernetes",
      "create-token",
      "--cloud-id", "${var.YC_CLOUD_ID}",
      "--folder-id", "${var.YC_FOLDER_ID}",
      "--token", "${var.YC_TOKEN}",
    ]
  }
}

provider "kubectl" {
  host = "${data.yandex_kubernetes_cluster.this.master[0].external_v4_endpoint}"
  cluster_ca_certificate = "${data.yandex_kubernetes_cluster.this.master[0].cluster_ca_certificate}"
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command = "yc"
    args = [
      "managed-kubernetes",
      "create-token",
      "--cloud-id", "${var.YC_CLOUD_ID}",
      "--folder-id", "${var.YC_FOLDER_ID}",
      "--token", "${var.YC_TOKEN}",
    ]
  }
}