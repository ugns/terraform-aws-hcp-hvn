module "label" {
  source  = "cloudposse/label/null"
  version = "0.25.0"

  attributes      = ["hvn"]
  id_length_limit = 36
  context         = module.this.context
}

resource "hcp_hvn" "this" {
  count = local.enabled ? 1 : 0

  hvn_id         = module.label.id
  cloud_provider = "aws"
  region         = var.hvn_region
  cidr_block     = var.hvn_cidr_block
}

locals {
  enabled = module.this.enabled
}