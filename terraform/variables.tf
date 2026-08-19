variable "kubeconfig_path" {
  description = "Path to the Kubernetes kubeconfig file."
  type        = string
  default     = "~/.kube/config"
}

variable "kube_context" {
  description = "Kubernetes context Terraform should manage."
  type        = string
  default     = "minikube"
}

variable "staging_namespace" {
  description = "Kubernetes namespace used for KijaniKiosk staging."
  type        = string
  default     = "kijani-staging"
}
