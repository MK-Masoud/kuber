# Configure the Azure provider
provider "azurerm" {
  features {}
  subscription_id = "aaf76651-a8e8-4960-bf98-c4170867b797"
  tenant_id       = "f5db126c-d827-43bc-a3d9-ae51b193c07c"
  client_id =    "bd18bc9c-d856-4c89-a9fe-57620a022026"
  client_secret =   "XLe8Q~HKn31sKsCwVtoxQ3hFKpHxZlK_BgSXnckU"

  
}
/*/
# Configure the Azure Container Registry (ACR) provider
provider "azurerm" {
  features {}
}
/*/
# Define variables
variable "resource_group_name" {
  description = "Name of the Azure Resource Group"
  default= "dockerCICD"
}

variable "location" {
  description = "Azure region"
  default= "eastus"
}

variable "app_service_name" {
  description = "Name of the Azure App Service"
  default= "azure-serviceapp"
}

variable "app_service_plan_name" {
  description = "Name of the Azure App Service Plan"
  default= "azure-webapp"
}

variable "sku_tier" {
  description = "SKU tier of the App Service Plan"
  default     = "Basic"
}

variable "sku_size" {
  description = "SKU size of the App Service Plan"
  default     = "B1"
}

variable "docker_image" {
  description = "Docker image URL"
  default= "masoud.azurecr.io"
}

variable "acr_name" {
  description = "Name of the Azure Container Registry"
  default= "masoud"
}
 /*
# Create resource group
resource "azurerm_resource_group" "example" {
  name     = var.resource_group_name
  location = var.location
}
*/
# Create Azure App Service Plan
resource "azurerm_app_service_plan" "example" {
  name                = var.app_service_plan_name
  location            = var.location
  resource_group_name = data.azurerm_resource_group.dockerCICD.name
reserved= true
kind="linux"
  sku {
    tier = var.sku_tier
    size = var.sku_size
    
  }
}

# Create Azure App Service
resource "azurerm_app_service" "example" {
  name                = var.app_service_name
  location            = var.location
  resource_group_name = data.azurerm_resource_group.dockerCICD.name
  app_service_plan_id = azurerm_app_service_plan.example.id
  
  site_config {
    always_on        = true
    linux_fx_version = "DOCKER|${var.docker_image}"
    
    
    
  }

  app_settings = {
    "DOCKER_REGISTRY_SERVER_URL" = "https://${var.acr_name}.azurecr.io"
    "DOCKER_REGISTRY_SERVER_USERNAME" = var.acrusername
    "DOCKER_REGISTRY_SERVER_PASSWORD" = var.acrpassowrd
  }
}

# Data source to retrieve ACR credentials
data "azurerm_container_registry" "example" {
  name                = var.acr_name
  resource_group_name = data.azurerm_resource_group.dockerCICD.name
}
variable "acrusername"{
    default= "admin"
}

variable "acrpassowrd"{
    default= "pA2m0fuIHw8lhUzdqBEL3QtEJPWCi2zizytfk/0vOE+ACRA9Ft4n"
}

data "azurerm_resource_group" "dockerCICD" {
name= "dockerCICD"

}
