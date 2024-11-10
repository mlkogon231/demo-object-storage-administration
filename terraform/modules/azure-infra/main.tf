resource "azurerm_resource_group" "infra" {
  name     = "${var.project_name}-${var.environment}-rg"
  location = var.location
  tags     = var.tags
}

resource "azurerm_virtual_network" "infra" {
  name                = "${var.project_name}-${var.environment}-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.infra.location
  resource_group_name = azurerm_resource_group.infra.name
  tags               = var.tags
}

# Create separate subnet resources instead of inline subnet blocks
resource "azurerm_subnet" "frontend" {
  name                 = "frontend"
  resource_group_name  = azurerm_resource_group.infra.name
  virtual_network_name = azurerm_virtual_network.infra.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "backend" {
  name                 = "backend"
  resource_group_name  = azurerm_resource_group.infra.name
  virtual_network_name = azurerm_virtual_network.infra.name
  address_prefixes     = ["10.0.2.0/24"]
  service_endpoints    = ["Microsoft.Storage"]  # Add Storage service endpoint
}

resource "azurerm_subnet" "management" {
  name                 = "management"
  resource_group_name  = azurerm_resource_group.infra.name
  virtual_network_name = azurerm_virtual_network.infra.name
  address_prefixes     = ["10.0.3.0/24"]
}

resource "azurerm_network_interface" "vm" {
  name                = "${var.project_name}-${var.environment}-vm-nic"
  location            = azurerm_resource_group.infra.location
  resource_group_name = azurerm_resource_group.infra.name
  tags               = var.tags

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.frontend.id  # Updated reference
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "main" {
  name                = "${var.project_name}-${var.environment}-vm"
  resource_group_name = azurerm_resource_group.infra.name
  location            = azurerm_resource_group.infra.location
  size                = var.vm_size
  admin_username      = var.admin_username
  tags               = var.tags

  network_interface_ids = [
    azurerm_network_interface.vm.id,
  ]

  admin_ssh_key {
    username   = var.admin_username
    public_key = file(var.ssh_key_path)
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
}

  identity {
    type = "SystemAssigned"
  }
}

# Frontend NSG
resource "azurerm_network_security_group" "frontend" {
  name                = "${var.project_name}-${var.environment}-frontend-nsg"
  location            = azurerm_resource_group.infra.location
  resource_group_name = azurerm_resource_group.infra.name
  tags               = var.tags

  security_rule {
    name                       = "allow-ssh"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range         = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "allow-http"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range         = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "allow-https"
    priority                   = 120
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range         = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Backend NSG
resource "azurerm_network_security_group" "backend" {
  name                = "${var.project_name}-${var.environment}-backend-nsg"
  location            = azurerm_resource_group.infra.location
  resource_group_name = azurerm_resource_group.infra.name
  tags               = var.tags

  security_rule {
    name                       = "allow-ssh-internal"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range         = "*"
    destination_port_range     = "22"
    source_address_prefix      = "10.0.1.0/24"  # Only from frontend subnet
    destination_address_prefix = "*"
  }
}

# Management NSG
resource "azurerm_network_security_group" "management" {
  name                = "${var.project_name}-${var.environment}-management-nsg"
  location            = azurerm_resource_group.infra.location
  resource_group_name = azurerm_resource_group.infra.name
  tags               = var.tags

  security_rule {
    name                       = "allow-ssh-internal"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range         = "*"
    destination_port_range     = "22"
    source_address_prefix      = "VirtualNetwork"  # Only from within the VNet
    destination_address_prefix = "*"
  }
}

# Associate NSGs with subnets
resource "azurerm_subnet_network_security_group_association" "frontend" {
  subnet_id                 = azurerm_virtual_network.infra.subnet.*.id[0]
  network_security_group_id = azurerm_network_security_group.frontend.id
}

resource "azurerm_subnet_network_security_group_association" "backend" {
  subnet_id                 = azurerm_virtual_network.infra.subnet.*.id[1]
  network_security_group_id = azurerm_network_security_group.backend.id
}

resource "azurerm_subnet_network_security_group_association" "management" {
  subnet_id                 = azurerm_virtual_network.infra.subnet.*.id[2]
  network_security_group_id = azurerm_network_security_group.management.id
}

resource "azurerm_storage_account" "minio" {
  name                     = lower(replace("${var.project_name}${var.environment}st", "-", ""))
  resource_group_name      = azurerm_resource_group.infra.name
  location                 = azurerm_resource_group.infra.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind            = "StorageV2"
  is_hns_enabled          = true  # Keep HNS enabled for better MinIO performance
  tags                    = var.tags

  blob_properties {
    last_access_time_enabled = true
    # Removed versioning_enabled as it's not compatible with HNS

    container_delete_retention_policy {
      days = 7
    }

    delete_retention_policy {
      days = 7
    }
  }

  network_rules {
    default_action             = "Allow"  # Temporarily change from "Deny" to "Allow"
    ip_rules                  = []
    virtual_network_subnet_ids = [azurerm_subnet.backend.id]
  }
}

# Create a container for MinIO
resource "azurerm_storage_container" "minio_data" {
  name                  = "minio-data"
  storage_account_name  = azurerm_storage_account.minio.name
  container_access_type = "private"
}