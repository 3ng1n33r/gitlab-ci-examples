variable "YC_FOLDER_ID" {
  type = string
  description = "Yandex Cloud folder_id"
}

variable "YC_TOKEN" {
  type = string
  description = "Yandex Cloud token"
}

variable "YC_CLOUD_ID" {
  type = string
  description = "Yandex Cloud cloud_id"
}

variable "az" {
  type = string
  default = "ru-central1-a"
  description = "Yandex Cloud availability zone"
}

variable "k8s_namespace" {
  type = string
  default = "flask-app-production"
  description = "k8s namespace for application"
}