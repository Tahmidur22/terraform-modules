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

resource "azurerm_network_security_group" "public_subnet_nsg" {
  name                = "${var.vnet_name}-public-subnet-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_network_security_rule" "private_allow_aks_internal" {
  name                        = "Allow-AKS-Internal"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "VirtualNetwork"
  source_port_range           = "*"
  destination_port_range      = "*"
  network_security_group_name = azurerm_network_security_group.aks_private_subnet_nsg.name
  resource_group_name         = var.resource_group_name
}

resource "azurerm_network_security_rule" "private_allow_outbound_internet" {
  name                        = "Allow-Internet-Outbound"
  priority                    = 200
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "Internet"
  source_port_range           = "*"
  destination_port_range      = "*"
  network_security_group_name = azurerm_network_security_group.aks_private_subnet_nsg.name
  resource_group_name         = var.resource_group_name
}

resource "azurerm_network_security_rule" "public_allow_http_internet" {
  name                        = "Allow-HTTP-Internet"
  priority                    = 1000
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "Internet"
  destination_address_prefix  = "*"
  network_security_group_name = azurerm_network_security_group.public_subnet_nsg.name
  resource_group_name         = var.resource_group_name
}

resource "azurerm_network_security_rule" "public_allow_https_internet" {
  name                        = "Allow-HTTPS-Internet"
  priority                    = 1001
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "Internet"
  destination_address_prefix  = "*"
  network_security_group_name = azurerm_network_security_group.public_subnet_nsg.name
  resource_group_name         = var.resource_group_name
}

resource "azurerm_network_security_rule" "public_allow_internal" {
  name                        = "Allow-Internal-Subnets"
  priority                    = 200
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "VirtualNetwork"
  source_port_range           = "*"
  destination_port_range      = "*"
  network_security_group_name = azurerm_network_security_group.public_subnet_nsg.name
  resource_group_name         = var.resource_group_name
}

resource "azurerm_subnet_network_security_group_association" "aks_private_subnet_nsg_association" {
  subnet_id                 = azurerm_subnet.aks_private_subnet.id
  network_security_group_id = azurerm_network_security_group.aks_private_subnet_nsg.id
}

resource "azurerm_subnet_network_security_group_association" "public_nsg_association" {
  subnet_id                 = azurerm_subnet.public_subnet.id
  network_security_group_id = azurerm_network_security_group.public_subnet_nsg.id
}
