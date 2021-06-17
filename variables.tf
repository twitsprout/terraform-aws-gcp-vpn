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
variable "gcp_cidr" {
  description = "CIDR group for GCP network"
  type        = string
}

variable "gcp_network" {
  description = "Network name for GCP"
  type        = string
}

variable "aws_vpc" {
  description = "VPC ID for AWS"
  type        = string
}

variable "aws_route_tables_ids" {
  description = "Routing table ID for AWS"
  type        = list(string)
}

variable "gcp_asn" {
  description = "Google Cloud side ASN"
  type        = number
}