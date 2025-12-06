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
    name                = "${var.vnet_name}-aks-private-subnet"
    resource_group_name = var.resource_group_name
    virtual_network_name= azurerm_virtual_network.network.name
    address_prefixes    = [var.ask_subnet_cidr]
}

resource "azurerm_subnet" "public_subnet" {
    name                = "${var.vnet_name}-public-subnet"
    resource_group_name = var.resource_group_name
    virtual_network_name= azurerm_virtual_network.network.name
    address_prefixes    = [var.public_subnet_cidr]
}