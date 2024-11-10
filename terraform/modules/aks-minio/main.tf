resource "azurerm_kubernetes_cluster" "aks" {
  name                = "${var.project_name}-${var.environment}-aks"
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix         = "${var.project_name}-${var.environment}"
  kubernetes_version = "1.27"  # Specify your desired version

  default_node_pool {
    name                = "default"
    node_count          = var.node_count
    vm_size            = var.node_size
    enable_auto_scaling = false
    vnet_subnet_id     = var.subnet_id
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin     = "azure"
    load_balancer_sku = "standard"
  }

  tags = var.tags
}