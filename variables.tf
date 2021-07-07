variable "name" {
  description = "Name applied to this instance"
  type        = string
  default     = ""
}

variable "customer" {
  description = "Customer applied to this instance"
  type        = string
  default     = ""
}

variable "environment" {
  description = "Environment applied to this instance"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Tags applied to this instance"
  type        = map(string)
  default = {
    "ManagedBy" = "terraform"
  }
}

# bellow are specific modules variables
variable "gcp_network" {
  description = "Network name for GCP"
  type        = string
}

variable "gcp_subnetworks" {
  description = "Routing table ID for AWS. By default it will take all the subnetworks in the VPC"
  type        = list(object({
      name = string
      region = string
    }))
  default     = null
}

variable "aws_vpc" {
  description = "VPC ID for AWS"
  type        = string
}

variable "aws_route_tables_ids" {
  description = "Routing table ID for AWS. By default it will take all the route tables in the VPC"
  type        = list(string)
  default     = null
}

variable "gcp_asn" {
  description = "Google Cloud side ASN"
  type        = number
}

variable "cloud_dns_route_propagation" {
  description = "Wether you want to add GCP Cloud DNS (35.199.192.0/19) to propagated routes, so that you can use Cloud DNS zone forwarding to AWS"
  type        = bool
  default     = false
}

variable "ha_vpn" {
  description = "Creates an HA VPN with two tunnels"
  type        = bool
  default     = false
}
