variable "resource_group_name" {
  type        = string
  description = "Name of the resource group"
  default     = "app-minio-storage-demo-rg"
}

variable "location" {
  type        = string
  description = "Azure region to deploy resources"
  default     = "westus2"  # Changed to westus2
}

variable "cluster_name" {
  type        = string
  description = "Name of the AKS cluster"
  default     = "minio-aks-demo"
}

variable "node_count" {
  type        = number
  description = "Number of nodes in the default node pool"
  default     = 1  # Changed to single node
}

variable "node_size" {
  type        = string
  description = "Size of the nodes in the default node pool"
  default     = "Standard_B2s_v2"
}

variable "use_spot_instances" {
  type        = bool
  description = "Whether to use spot instances for the node pool"
  default     = true
}

variable "spot_price" {
  type        = number
  description = "Maximum price for spot instances (-1 for market price)"
  default     = -1
}

variable "kubernetes_version" {
  type        = string
  description = "Kubernetes version"
  default     = "1.27"
}