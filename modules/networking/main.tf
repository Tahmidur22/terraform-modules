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

resource "azurerm_network_security_group" "aks_private_subnet_nsg" {
  name                = "${var.vnet_name}-aks-private-subnet-nsg"
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

resource "azurerm_network_security_rule" "azure_lb" {
  name                        = "Allow-AzureLoadBalancer"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_address_prefix       = "AzureLoadBalancer"
  destination_address_prefix  = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  network_security_group_name = azurerm_network_security_group.aks_private_subnet_nsg.name
  resource_group_name         = var.resource_group_name
}

resource "azurerm_network_security_rule" "nodeports" {
  name                        = "Allow-AKS-NodePorts"
  priority                    = 120
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  source_port_range           = "*"
  destination_port_ranges     = ["30000-32767"]
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

resource "azurerm_network_security_rule" "allow_http_https" {
  name                        = "Allow-HTTP-HTTPS"
  priority                    = 130
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  source_port_range           = "*"
  destination_port_ranges     = ["80", "443"]
  network_security_group_name = azurerm_network_security_group.aks_private_subnet_nsg.name
  resource_group_name         = var.resource_group_name
}


resource "azurerm_subnet_network_security_group_association" "aks_private_subnet_nsg_association" {
  subnet_id                 = azurerm_subnet.aks_private_subnet.id
  network_security_group_id = azurerm_network_security_group.aks_private_subnet_nsg.id
}
