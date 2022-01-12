variable "rg_name" {
  description = "Resource Group name"
  type        = string
  default     = ""
}

variable "location" {
  description = "Azure location"
  type        = string
  default     = ""
}

variable "failover_location" {
  description = "Specifies a geo_location resource, used to define where data should be replicated with the failover_priority 0 specifying the primary location."
  type        = string
  default     = "eastasia"
}