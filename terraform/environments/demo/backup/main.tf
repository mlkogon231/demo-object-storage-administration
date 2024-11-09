# variable "resource_group_name" {
#   type        = string
#   description = "Name of the resource group"
#   default     = "app-minio-storage-demo-rg"
# }

# variable "location" {
#   type        = string
#   description = "Azure region to deploy resources"
#   default     = "westus2"
#  }

# variable "cluster_name" {
#   type        = string
#   description = "Name of the AKS cluster"
#   default     = "minio-aks-demo"
# }

# variable "node_count" {
#   type        = number
#   description = "Number of nodes in the default node pool"
#   default     = 1  # Changed to single node
# }

# variable "node_size" {
#   type        = string
#   description = "Size of the nodes in the default node pool"
#   default     = "Standard_B2s_v2"  # Cost-effective burstable VM
# }

# variable "kubernetes_version" {
#   type        = string
#   description = "Kubernetes version"
#   default     = "1.29"
# }