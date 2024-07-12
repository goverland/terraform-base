variable "customer_names" {
    description = "Subscription name used to tag resources"
    type        = list(string)
}

variable "subscription_group_name" {
    description = "Subscription name used to tag resources"
    type        = string 
}

variable "shared_app_config_id" {
  description = "The ID of the shared app configuration"
  type        = string
  
}

variable "shared_appconf_dataowner_id" {
  description = "The ID of the shared app configuration data owner"
  type        = string
}