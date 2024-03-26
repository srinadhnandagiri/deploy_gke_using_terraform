provider "google" {
  credentials = file(var.path_to_json)

  project = var.project
  region  = var.region
}
data "google_client_config" "default" {}
data "google_container_cluster" "gke_cluster" {
  name     = var.gke_cluster_name
  location = var.region
  project = var.project
} 
provider "kubernetes" {
  host                   = "https://${data.google_container_cluster.gke_cluster.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(data.google_container_cluster.gke_cluster.master_auth[0].cluster_ca_certificate)
  # If necessary, configure other authentication settings like token, certificate, etc.
}
resource "kubernetes_namespace" "namespace" {
  metadata {
    name = var.namespace_name
  }
}
resource "kubernetes_deployment" "deployment" {
  metadata {
    name      = var.deployment_name
    namespace = kubernetes_namespace.namespace.metadata[0].name
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "nginx"
      }
    }

    template {
      metadata {
        labels = {
          app = "nginx"
        }
      }

      spec {
        container {
          image = var.image_name
          name  = "nginx"

          port {
            container_port = var.container_port
          }
        }
      }
    }
  }
}
resource "kubernetes_service" "service" {
  metadata {
    name      = var.service_name
    namespace = kubernetes_namespace.namespace.metadata[0].name
  }

  spec {
    selector = {
      app = kubernetes_deployment.deployment.spec[0].template[0].metadata[0].labels.app
    }

    port {
      port        = var.service_port
      target_port = var.container_port
    }
    type = "NodePort"
  }
}
resource "kubernetes_ingress_v1" "ingress" {
  metadata {
    name = var.ingress_name
    namespace = kubernetes_namespace.namespace.metadata[0].name
  }

  spec {
    rule {
        # No hostname specified (matches any hostname)
        http {
          path { 
               path = "/"
               backend {
                 service {
                   name =  kubernetes_service.service.metadata[0].name
                   port {
                     number = kubernetes_service.service.spec[0].port[0].port
              }
            }
        }
      }
  }
}
}
}
