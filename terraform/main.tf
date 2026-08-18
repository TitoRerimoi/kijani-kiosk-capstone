terraform {
  required_version = ">= 1.5.0"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.38"
    }
  }
}

provider "kubernetes" {
  config_path    = var.kubeconfig_path
  config_context = var.kube_context
}

resource "kubernetes_namespace" "kijani_staging" {
  metadata {
    name = var.staging_namespace

    labels = {
      environment = "staging"
      project     = "kijani-kiosk"
      managed_by  = "terraform"
    }
  }
}
