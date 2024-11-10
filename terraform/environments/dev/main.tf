module "root" {
  source = "../.."
  
  project_name   = var.project_name
  environment    = var.environment
  location       = var.location
  admin_username = var.admin_username
  ssh_key_path   = var.ssh_key_path
}