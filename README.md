# terraform-aws-gcp-vpn

Terraform module to create an HA VPN between AWS and GCP.

The purpose of this project is to setup an HA VPN connection between AWS and GCP based on the following documentation :

- [GCP  ha vpn](https://cloud.google.com/network-connectivity/docs/vpn/how-to/creating-ha-vpn)
- [AWS vpn setup connection](https://docs.aws.amazon.com/vpn/latest/s2svpn/SetUpVPNConnections.html)

## Compatibility

This module is meant for use with Terraform 0.13 and further. This has been tested with provider `google` in version 3.3 and `aws` in 3.25.

## Example

Example of how to use this module can be found in the [example](example) folder.

```hcl
module "gcp-vpn" {
  source  = "build-and-run/gcp-vpn/aws"
  version = "1.0"

  aws_vpc            = aws_vpc.default.id
  gcp_network        = google_compute_network.vpc.name
  
  gcp_asn            = 65500
}
```

## Firewall rules / security group

This module does no handle AWS Security Groups creation and GCP firewall rules. After setting up the VPN, you have to create them to allow traffic between your VPCs.

## Cloud DNS

This module can route the traffic from GCP Cloud DNS to AWS using the CIDR *35.199.192.0/19*. This means you can setup Forwarding Zones in Cloud DNS and route them to AWS (provided you setup the Security Groups rules).

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13 |
| aws | ~>3.25 |
| google | ~> 3.3 |

## Providers

| Name | Version |
|------|---------|
| aws | ~>3.25 |
| google | ~> 3.3 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| aws\_vpc | VPC ID for AWS | `string` | n/a | yes |
| gcp\_asn | Google Cloud side ASN | `number` | n/a | yes |
| gcp\_network | Network name for GCP | `string` | n/a | yes |
| aws\_route\_tables\_ids | Routing table ID for AWS. By default it will take all the route tables in the VPC | `list(string)` | `null` | no |
| cloud\_dns\_route\_propagation | Wether you want to add GCP Cloud DNS (35.199.192.0/19) to propagated routes, so that you can use Cloud DNS zone forwarding to AWS | `bool` | `false` | no |
| customer | Customer applied to this instance | `string` | `""` | no |
| environment | Environment applied to this instance | `string` | `""` | no |
| gcp\_subnetworks | Routing table ID for AWS. By default it will take all the subnetworks in the VPC | <pre>list(object({<br>      name = string<br>      region = string<br>    }))</pre> | `null` | no |
| ha\_vpn | Creates an HA VPN with two tunnels | `bool` | `false` | no |
| name | Name applied to this instance | `string` | `""` | no |
| tags | Tags applied to this instance | `map(string)` | <pre>{<br>  "ManagedBy": "terraform"<br>}</pre> | no |

## Outputs

No output.