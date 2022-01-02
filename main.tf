data "aws_vpc" "peer" {
  id = var.vpc_id
}

data "aws_arn" "peer" {
  arn = data.aws_vpc.peer.arn
}

resource "hcp_hvn" "this" {
  hvn_id         = var.hvn.id
  cloud_provider = "aws"
  region         = var.hvn.region
  cidr_block     = var.hvn.cidr_block
}

// ===== HVN with peering connection
resource "hcp_aws_network_peering" "this" {
  count = local.peering_connection

  hvn_id          = hcp_hvn.this.hvn_id
  peering_id      = var.connection.id
  peer_vpc_id     = data.aws_vpc.peer.id
  peer_account_id = data.aws_vpc.peer.owner_id
  peer_vpc_region = data.aws_arn.peer.region
}

resource "aws_vpc_peering_connection_accepter" "this" {
  count = local.peering_connection

  vpc_peering_connection_id = hcp_aws_network_peering.this[0].provider_peering_id
  auto_accept               = true
}

// ===== HVN with transit gateway
data "aws_ec2_transit_gateway" "this" {
  id = var.connection.tgw_id
}

resource "aws_ram_resource_share" "this" {
  count = local.transit_gateway

  name                      = "hcp-hvn-resource-share"
  allow_external_principals = true
}

resource "aws_ram_principal_association" "this" {
  count = local.transit_gateway

  resource_share_arn = aws_ram_resource_share.this[0].arn
  principal          = hcp_hvn.this.provider_account_id
}

resource "aws_ram_resource_association" "this" {
  count = local.transit_gateway

  resource_share_arn = aws_ram_resource_share.this[0].arn
  resource_arn       = data.aws_ec2_transit_gateway.this.arn
}

resource "hcp_aws_transit_gateway_attachment" "this" {
  count = local.transit_gateway

  hvn_id                        = hcp_hvn.this.hvn_id
  transit_gateway_attachment_id = coalesce(var.connection.attachment_id, format("hvn-%s-tgw-attachment", var.hvn.id))
  transit_gateway_id            = data.aws_ec2_transit_gateway.this.id
  resource_share_arn            = aws_ram_resource_share.this[0].arn

  depends_on = [
    aws_ram_principal_association.this,
    aws_ram_resource_association.this
  ]
}

resource "aws_ec2_transit_gateway_vpc_attachment_accepter" "this" {
  transit_gateway_attachment_id = hcp_aws_transit_gateway_attachment.this[0].provider_transit_gateway_attachment_id
}

resource "hcp_hvn_route" "this" {
  count = var.connection.id != null ? 1 : 0

  hvn_link         = hcp_hvn.this.self_link
  hvn_route_id     = coalesce(var.connection.attachment_id, format("hvn-%s-to-%s-route", var.hvn.id, var.connection.type))
  destination_cidr = data.aws_vpc.peer.cidr_block
  target_link      = var.connection.type == "pcx" ? hcp_aws_network_peering.this[0].self_link : hcp_aws_transit_gateway_attachment.this[0].self_link
}
