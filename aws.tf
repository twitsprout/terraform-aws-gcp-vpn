resource "aws_customer_gateway" "customer_gateway1" {
  bgp_asn    = var.gcp_asn
  ip_address = google_compute_ha_vpn_gateway.ha_vpn_gateway.vpn_interfaces[0].ip_address
  type       = "ipsec.1"

  tags       = merge({ Name = var.name }, local.interpolated_tags)
}

resource "aws_customer_gateway" "customer_gateway2" {
  bgp_asn    = var.gcp_asn
  ip_address = google_compute_ha_vpn_gateway.ha_vpn_gateway.vpn_interfaces[1].ip_address
  type       = "ipsec.1"

  tags       = merge({ Name = var.name }, local.interpolated_tags)
}

resource "aws_vpn_gateway" "default" {
  vpc_id = "${var.aws_vpc}"

  tags   = merge({ Name = var.name }, local.interpolated_tags)
}

resource "aws_vpn_connection" "vpn1" {
  vpn_gateway_id      = aws_vpn_gateway.default.id
  customer_gateway_id = aws_customer_gateway.customer_gateway1.id
  type                = aws_customer_gateway.customer_gateway1.type

  tags                = merge({ Name = var.name }, local.interpolated_tags)
}

resource "aws_vpn_connection" "vpn2" {
  vpn_gateway_id      = aws_vpn_gateway.default.id
  customer_gateway_id = aws_customer_gateway.customer_gateway2.id
  type                = aws_customer_gateway.customer_gateway2.type

  tags                = merge({ Name = var.name }, local.interpolated_tags)
}

resource "aws_route" "gcp" {
  count                  = length(var.aws_route_tables_ids)
  route_table_id         = var.aws_route_tables_ids[count.index]
  gateway_id             = aws_vpn_gateway.default.id
  destination_cidr_block = var.gcp_cidr

  # NB: tags not supported here
  # tags = merge({Name = var.name}, local.interpolated_tags)
}

# Allow inbound access to VPC resources from GCP CIDR
resource "aws_security_group_rule" "google_ingress_vpn" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = [var.gcp_cidr]
  security_group_id = var.aws_sg

  # NB: tags not supported here
  # tags = merge({Name = var.name}, local.interpolated_tags)
}

# Allow outbound access from VPC resources to GCP CIDR
resource "aws_security_group_rule" "google_egress_vpn" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = [var.gcp_cidr]
  security_group_id = var.aws_sg

  # NB: tags not supported here
  # tags = merge({Name = var.name}, local.interpolated_tags)
}
