resource "aws_customer_gateway" "customer_gateway1" {
  bgp_asn    = var.gcp_asn
  ip_address = google_compute_ha_vpn_gateway.ha_vpn_gateway.vpn_interfaces[0].ip_address
  type       = "ipsec.1"

  tags       = merge({ Name = var.name }, local.interpolated_tags)
}

resource "aws_customer_gateway" "customer_gateway2" {
  count      = var.ha_vpn ? 1 : 0
  bgp_asn    = var.gcp_asn
  ip_address = google_compute_ha_vpn_gateway.ha_vpn_gateway.vpn_interfaces[1].ip_address
  type       = "ipsec.1"

  tags       = merge({ Name = var.name }, local.interpolated_tags)
}

resource "aws_vpn_gateway" "default" {
  vpc_id = var.aws_vpc

  tags   = merge({ Name = var.name }, local.interpolated_tags)
}

resource "aws_vpn_connection" "vpn1" {
  vpn_gateway_id      = aws_vpn_gateway.default.id
  customer_gateway_id = aws_customer_gateway.customer_gateway1.id
  type                = aws_customer_gateway.customer_gateway1.type

  tags                = merge({ Name = var.name }, local.interpolated_tags)
}

resource "aws_vpn_connection" "vpn2" {
  count      = var.ha_vpn ? 1 : 0
  vpn_gateway_id      = aws_vpn_gateway.default.id
  customer_gateway_id = aws_customer_gateway.customer_gateway2[0].id
  type                = aws_customer_gateway.customer_gateway2[0].type

  tags                = merge({ Name = var.name }, local.interpolated_tags)
}

data "aws_route_tables" "rts" {
  vpc_id = var.aws_vpc
}

resource "aws_vpn_gateway_route_propagation" "gcp" {
  for_each             = var.aws_route_tables_ids != null ? toset(var.aws_route_tables_ids) : data.aws_route_tables.rts.ids
  vpn_gateway_id       = aws_vpn_gateway.default.id
  route_table_id       = each.value
}
