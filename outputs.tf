output "hcp_hvn_id" {
  description = "Hashicorp Cloud Platform HVN ID"
  value       = hcp_hvn.this[0].hvn_id
}

output "hcp_hvn_cidr_block" {
  description = "Hashicorp Cloud Platform CIDR block"
  value       = hcp_hvn.this[0].cidr_block
}
