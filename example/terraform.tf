# Create a VPC to launch our instances into
resource "aws_vpc" "default" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags {
    "Name" = var.namespace
  }
}

# Create an internet gateway to give our subnet access to the outside world
resource "aws_internet_gateway" "default" {
  vpc_id = aws_vpc.default.id

  tags {
    "Name" = var.namespace
  }
}

# Grant the VPC internet access on its main route table
resource "aws_route" "internet_access" {
  route_table_id         = aws_vpc.default.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.default.id
}

# Create a subnet to launch our instances into
resource "aws_subnet" "default" {
  count                   = length(var.private_subnets)
  vpc_id                  = aws_vpc.default.id
  availability_zone       = var.aws[count.index]
  cidr_block              = var.private_subnets[count.index]
  map_public_ip_on_launch = true

  tags {
    "Name" = var.namespace
  }
}

# Create a VPC to launch our instances into
resource "google_compute_network" "vpc" {
  auto_create_subnetworks = false
  name                    = "vpc"
  routing_mode            = "REGIONAL"
}

resource "google_compute_subnetwork" "vpc_subnetworks" {
  ip_cidr_range = "10.128.0.0/20"
  name          = "vpc-subnetworks"
  network       = google_compute_network.vpc.id
  project       = "project"
  region        = "us-east-1"
}

module "gcp-vpn" {
  source  = "build-and-run/gcp-vpn/aws"
  version = "1.0"

  aws_vpc            = aws_vpc.default.id
  gcp_network        = google_compute_network.vpc.name
  
  gcp_asn            = 65500
}
