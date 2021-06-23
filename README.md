# terraform-aws-gcp-vpn

Terraform module to create an HA VPN between AWS and GCP.

The purpose of this project is to setup an HA VPN connection between AWS and GCP based on the following documentation :

- [GCP  ha vpn](https://cloud.google.com/network-connectivity/docs/vpn/how-to/creating-ha-vpn)
- [AWS vpn setup connection](https://docs.aws.amazon.com/vpn/latest/s2svpn/SetUpVPNConnections.html)

## Compatibility

This module is meant for use with Terraform 0.13 and further. This has been tested with provider `google` in version 3.3 and `aws` in 3.25.

## Example

Example of how to use this module can be found in the [example](example) folder.

## Firewall rules / security group

This module does no handle AWS Security Groups creation and GCP firewall rules. After setting up the VPN, you have to create them to allow traffic between your VPCs.

## Cloud DNS

This module can route the traffic from GCP Cloud DNS to AWS using the CIDR *35.199.192.0/19*. This means you can setup Forwarding Zones in Cloud DNS and route them to AWS (provided you setup the Security Groups rules).
