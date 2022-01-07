module "example" {
  source = "../.."

  hvn_region = var.region

  context = module.this.context
}
