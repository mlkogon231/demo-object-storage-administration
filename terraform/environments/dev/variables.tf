# environments/dev/variables.tf
variable "project_name" {
  type        = string
  description = "Name of the project, used as prefix for all resources"
  default     = "azminmulti"
}

variable "environment" {
  type        = string
  description = "Environment name"
  default     = "dev"
}

variable "location" {
  type        = string
  description = "Azure region"
  default     = "eastus"
}

variable "admin_username" {
  type        = string
  description = "Admin username for the VM"
  default     = "mkogon"
}

variable "ssh_key_path" {
  type        = string
  description = "Path to the SSH public key file"
  default     = "../../../observability-rg-key.pem.pub"
}

variable "node_count" {
  type        = number
  description = "Number of AKS nodes"
  default     = 1
}

variable "node_size" {
  type        = string
  description = "Size of the AKS nodes"
  default     = "Standard_D2s_v3"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to all resources"
  default = {
    environment = "dev"
    managed_by  = "terraform"
    project     = "azure-minio-multi"
  }
}