resource "kubernetes_deployment" "app" {
  metadata {
    name      = "my-app"
    namespace = "default"
  }

  spec {
    replicas = 2
    selector {
      match_labels = {
        app = "my-app"
      }
    }
    template {
      metadata {
        labels = {
          app = "my-app"
        }
      }
      spec {
        container {
          name  = "my-app"
          image = "dockerhub_username/my-app:v1"  # Change to your DockerHub image
          port {
            container_port = 80
          }
        }
      }
    }
  }
depends_on = [
    module.eks,
    module.eks_worker
  ]
}

resource "kubernetes_service" "app" {
  metadata {
    name = "my-app-service"
  }
  spec {
    selector = {
      app = "my-app"
    }
    port {
      port        = 80
      target_port = 80
    }
    type = "LoadBalancer"
  }
depends_on = [
    module.eks,
    module.eks_worker
  ]
}
