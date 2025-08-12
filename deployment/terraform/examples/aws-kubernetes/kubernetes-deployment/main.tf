
provider "helm" {
  kubernetes = {
    config_path = var.kubeconfig_file
  }
}

provider "kubernetes" {
  config_path = var.kubeconfig_file
}

resource "kubernetes_ingress_class" "application_load_balancer" {
  # An Application Load Balancer  is required in order to create public URLs. 
  # The load balancer controller creates instances of the ALB when it sees ingress objects with the right annotations.
  metadata {
    name = "alb"
    labels = {
      "app.kubernetes.io/name" = "LoadBalancerController"
    }
  }
  spec {
    controller = "eks.amazonaws.com/alb"
  }
}


locals {
  services = {
    medcat_service = {
      path_prefix = "medcat-service"
    }
  }
}
module "cogstack_helm_services" {
  depends_on            = [kubernetes_ingress_class.application_load_balancer]
  source                = "../../../modules/cogstack-helm-services"
  medcat_service_values = <<EOT
ingress:
    annotations:
        alb.ingress.kubernetes.io/scheme: internet-facing
        alb.ingress.kubernetes.io/target-type: ip
        alb.ingress.kubernetes.io/healthcheck-path: /api/health/live
    className: alb
    http:
    - paths:
        - path: /${local.services.medcat_service.path_prefix}
          pathType: Prefix
EOT
}

