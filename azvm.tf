provider "azurerm" {
    features {}
}

data "azurerm_resource_group" "existing_rg" {
    name = "${var.azurerm_resource_group}"
}
data "azurerm_virtual_network" "existing_vnet" {
    name                = "${var.vnetname}"
    resource_group_name = "${data.azurerm_resource_group.existing_rg.name}"
}


resource "azurerm_virtual_machine" "myterraazvm" {
    name                          = "${var.name}VM"
    location                      = data.azurerm_resource_group.existing_rg.location
    resource_group_name           = data.azurerm_resource_group.existing_rg.name
    network_interface_ids         = ["${azurerm_network_interface.azterravnic.id}"]

    os_profile_windows_config {
        enable_automatic_upgrades = false
        provision_vm_agent       = true
    }

    
    #network_interface_ids         = ["${var.azurerm_network_interface.main-nic.id}"]
    # Specify the size of the VM (the number and type of CPUs/cores)
    vm_size                       = "${var.vmsize}" 
    
    # This will make this VM a Gen2 VM, as specified by the "gen2" variable above   
    # You can also specify "gen1" to create a Gen1 VM instead
    #os_type                        = "Windows"

    # Uncomment this line to use
    # Attach a managed disk to this VM
    storage_os_disk {
        name              = "myOsDisk101"
        caching           = "ReadWrite"
        create_option     = "FromImage"
        os_type           = "Windows"
        }
    # You can attach additional data disks if needed, but for simplicity we only have one here
    storage_image_reference {
        publisher = "MicrosoftWindowsServer"
        offer     = "WindowsServer"
        sku       = "2016-Datacenter"
        version   = "latest"
    }

    os_profile {
        computer_name  = "${var.name}VM"
        admin_username = "${var.adminuser}"
        admin_password = "${var.adminpasswrd}"
    }

    tags = {
        environment = "Terraform Demo"
    }
    
}

resource "azurerm_public_ip" "terrapublic" {
    name                = "terraPublicIP"
    location            = data.azurerm_resource_group.existing_rg.location
    resource_group_name = data.azurerm_resource_group.existing_rg.name
    allocation_method   = "Static"

    tags = {
        environment = "Terraform Demo"
    }
}

# resource "azurerm_network_security_group" "azsecurity" {
#     name                = "NetworkSecurityGroup1"
#     location            = data.azurerm_resource_group.existing_rg.location
#     resource_group_name = data.azurerm_resource_group.existing_rg.name
    
#     #security_rule.0.priority = 100

#       security_rule {
#     name                       = "test123"
#     priority                   = 100
#     direction                  = "Inbound"
#     access                     = "Allow"
#     protocol                   = "Tcp"
#     source_port_range          = "*"
#     destination_port_range     = "*"
#     source_address_prefix      = "*"
#     destination_address_prefix = "*"
#   }


#     security_rule {
#         access                     = "AllowRDP"
#         destination_address_prefix  = "*"
#         destination_port_range     = "3389"
#         direction                  = "Inbound"
#         priority                   = 100
#         protocol                   = "Tcp"
#         source_address_prefix      = "*"
#         source_port_range          = "*"
#     }  
    
    # security_rule.1.name  = "allowHTTPS"
    # security_rule  {
    #     name                       = "HTTPS"
    #     description                = "Allow HTTPS"
    #     access                     = "Allow"
    #     direction                  = "Outbound"
    #     protocol                   = "Tcp"
    #     source_port_range          = "*"
    #     destination_address_prefix = "*"
    #     destination_port_range     = "443"
    #     #port_range                 = "443" 
    #     source_address_prefix           = "*"
    #     #source_port_range              = "*"
    # }
    

    #depends_on = [ azurerm_virtual_machine.myterraazvm ]
    
    # security_rule  {
    #     name                       = "allowHTTPS"
    #     description                = "Allow HTTPS"
    #     direction                  = "Outbound"
    #     protocol                   = "Tcp"
    #     source_address_prefix      = "VirtualNetwork"
    #     destination_address_prefix = "*"
    #     #port_range                 = "443"
    # }

    #depends_on = [ azurerm_virtual_network.vnet ]


resource "azurerm_network_interface" "azterravnic" {
    name                = "${var.name}-NIC"
    location            = data.azurerm_resource_group.existing_rg.location
    resource_group_name = data.azurerm_resource_group.existing_rg.name
    #network_security_group_id = "${azurerm_network_security_group.azsecurity.id}"
    #network_security_group_id = "${azurerm_network_security_group.azsecurity.id}"
    ip_configuration {
        name                          = "testconfig"
        subnet_id                     = "${azurerm_subnet.terrasubnet.id}"
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          ="${azurerm_public_ip.terrapublic.id}"
    } 
}

resource "azurerm_subnet" "terrasubnet" {
    name                 = "${var.subnetname}"
    virtual_network_name = data.azurerm_virtual_network.existing_vnet.name
    address_prefixes      = "${var.subnetaddressrange}"
    resource_group_name =  data.azurerm_resource_group.existing_rg.name
}

# Create a public IP address that this VM will use - note: this is not necessary if you're using an existing Public IP address
# Output variables that will show in Terraform console after apply phase
output "Virtual_Machine_ID" {
    value = "${azurerm_virtual_machine.myterraazvm.id}"
}

# resource "azurerm_subnet_network_security_group_association" "aznsgassoc" {
#     subnet_id              = "${azurerm_subnet.terrasubnet.id}"
#     network_security_group_id = "${azurerm_network_security_group.azsecurity.id}"

# }
