variable "project" { }

variable "path_to_json" { }

variable "region" {
  default = "asia-south1"
}
variable "gke_cluster_name" {
  default = "srinadh-test-cluster"
}
variable "namespace_name" {
  default = "terraform"
}
variable "deployment_name" {
  default = "nginx-deployment"
}
variable "container_port" {
  default = 80
}
variable "service_port" {
  default = 80
}
variable "service_name" {
  default = "nginx-service"
}
variable "ingress_name" {
  default = "nginx-ingress"
}
variable "image_name" {}
