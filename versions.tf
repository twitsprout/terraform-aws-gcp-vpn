terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~>3.25"
    }
    google = {
      source = "hashicorp/google"
      version = "~> 3.3"
    }
  }
  required_version = ">= 0.13"
}
