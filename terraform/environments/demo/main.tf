module "aks_minio" {
  source = "../../modules/aks-minio"

  resource_group_name = var.resource_group_name
  cluster_name       = var.cluster_name
  location           = var.location
  
  # Demo environment specific configurations
  node_count         = var.node_count
  node_size          = var.node_size
}

# Output the cluster credentials
output "kube_config" {
  value     = module.aks_minio.kube_config
  sensitive = true
}