resource "azurerm_virtual_network" "network" {
  name                = var.vnet_name
  address_space       = var.address_space
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = merge(var.tags, {
    module = "networking"
  })
}

resource "azurerm_subnet" "aks_private_subnet" {
  name                 = "${var.vnet_name}-aks-private-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.network.name
  address_prefixes     = [var.aks_subnet_cidr]
}

resource "azurerm_subnet" "public_subnet" {
  name                 = "${var.vnet_name}-public-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.network.name
  address_prefixes     = [var.public_subnet_cidr]
}

resource "azurerm_network_security_group" "aks_private_subnet_nsg" {
  name                = "${var.vnet_name}-aks-private-subnet-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_network_security_rule" "allow_http_internet" {
  name                        = "Allow-HTTP-Internet"
  priority                    = 1000
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "Internet"
  destination_address_prefix  = "*"

  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.aks_private_subnet_nsg.name
}

resource "azurerm_network_security_rule" "allow_https_internet" {
  name                        = "Allow-HTTPS-Internet"
  priority                    = 1001
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "Internet"
  destination_address_prefix  = "*"

  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.aks_private_subnet_nsg.name
}

resource "azurerm_network_security_rule" "allow_aks_internal" {
  name                        = "Allow-AKS-Internal"
  priority                    = 1002
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "VirtualNetwork"
  source_port_range           = "*"
  destination_port_range      = "*"

  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.aks_private_subnet_nsg.name
}

resource "azurerm_subnet_network_security_group_association" "aks_private_subnet_nsg_association" {
  subnet_id                 = azurerm_subnet.aks_private_subnet.id
  network_security_group_id = azurerm_network_security_group.aks_private_subnet_nsg.id
}