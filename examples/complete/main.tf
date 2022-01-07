module "example" {
  source = "../.."

  hvn_region = "us-east-1"

  context = module.this.context
}

module "example_with_cidr" {
  source = "../.."

  hvn_region     = "us-east-1"
  hvn_cidr_block = "172.25.16.0/20"

  context = module.this.context
}
