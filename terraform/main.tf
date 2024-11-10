terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

module "azure_infrastructure" {
  source = "./modules/azure-infra"
  
  project_name   = var.project_name
  environment    = var.environment
  location       = var.location
  admin_username = var.admin_username
  ssh_key_path   = var.ssh_key_path
  tags          = var.tags
}

module "aks_minio" {
  source = "./modules/aks-minio"
  
  project_name        = var.project_name
  environment         = var.environment
  location           = var.location
  resource_group_name = module.azure_infrastructure.resource_group_name
  subnet_id          = module.azure_infrastructure.backend_subnet_id  # We'll need to add this output
  tags               = var.tags
  
  node_count         = 1        # Adjust as needed
  node_size          = "Standard_D2s_v3"  # Cost-effective size for demo
}