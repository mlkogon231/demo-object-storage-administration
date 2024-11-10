variable "project_name" {
  type        = string
  description = "Name of the project"
}

variable "environment" {
  type        = string
  description = "Environment name"
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

variable "tags" {
  type        = map(string)
  description = "Resource tags"
  default = {
    managed_by = "terraform"
  }
}