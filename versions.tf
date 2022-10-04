terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.23.0"
    }
    google = {
      source = "hashicorp/google"
      version = "~> 4.25.0"
    }
  }
  required_version = ">= 0.13"
}
