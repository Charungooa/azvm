variable "name" {
    type = string
    default = "myterraaz"
}

variable "azurerm_resource_group" {
    description = "Name of the resource group in which to create the VM."
    type = string
    default = ""
}

variable "vmsize" {
    type = string
    #description = "The size/type of Azure VM. See https://azure.microsoft.com/en-us/documentation/articles/virtual"
    #description = "The size/type of Azure VM. See https://azure.microsoft.com/en-us/documentation/articles/"
    default = ""
}

variable "subnetname" {
    description = "Subnet name where the VM will be deployed."
    type = string
    default = ""
}

variable "vnetname" {
    description = "VNet name where the VM will be deployed."
    type = string
    default = ""
}

variable "subnetaddressrange" {
    description = "IP address range for subnet in CIDR notation (e.g., 10.0.0.0/24)."
    type = list(string)
    default = []
}

variable "adminuser" {
    description = "Administrator user name."
    default     = "azureuser"
}

variable "adminpasswrd" {
    description = "Password for administrator access."
    default = ""
    sensitive = true
    
}

# variable "azurerm_network_interface" {
#     description = "Network interface resource created by module azure_network."
#     type = object({
#         id   = string,
#         name = string
#     })
# }
