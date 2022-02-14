output "hcp_hvn_id" {
  description = "Hashicorp Cloud Platform HVN ID"
  value       = join("", hcp_hvn.this.*.hvn_id)
}

output "hcp_hvn_cidr_block" {
  description = "Hashicorp Cloud Platform CIDR block"
  value       = join("", hcp_hvn.this.*.cidr_block)
}
