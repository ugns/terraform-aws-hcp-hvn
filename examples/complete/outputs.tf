output "hvn_id" {
  description = "Hashicorp Cloud Platform HVN ID"
  value       = module.example.hcp_hvn_id
}

output "hvn_cidr_block" {
  description = "Hashicorp Cloud Platform CIDR block"
  value       = module.example.hcp_hvn_cidr_block
}
