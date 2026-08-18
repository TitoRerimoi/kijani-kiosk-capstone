output "staging_namespace" {
  description = "Name of the KijaniKiosk staging namespace."
  value       = kubernetes_namespace.kijani_staging.metadata[0].name
}

output "staging_environment" {
  description = "Environment label applied to the staging namespace."
  value       = kubernetes_namespace.kijani_staging.metadata[0].labels.environment
}
