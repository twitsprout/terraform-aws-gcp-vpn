locals {
  interpolated_tags = merge(
    { "Customer" = var.customer },
    { "Environment" = var.environment },
    var.tags
  )
  gcp_cloud_dns = "35.199.192.0/19"
}
