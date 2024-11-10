# modules/azure-infra/variables.tf

variable "project_name" {
  type        = string
  description = "Name of the project, used as prefix for all resources"
}

variable "environment" {
  type        = string
  description = "Environment (dev, staging, prod)"
}

variable "location" {
  type        = string
  description = "Azure region"
}

variable "admin_username" {
  type        = string
  description = "Admin username for the VM"
}

variable "ssh_key_path" {
  type        = string
  description = "Path to the SSH public key file"
}

variable "vm_size" {
  type        = string
  description = "Size of the Virtual Machine"
  default     = "Standard_B1s"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to all resources"
}