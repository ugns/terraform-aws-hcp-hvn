variable "vpc_id" {
  type        = string
  description = "AWS VPC ID"
}

variable "hvn" {
  type = object({
    id         = string
    region     = string
    cidr_block = string
  })
  description = "(optional) Hashicorp Cloud Platform HVN details"
  default = {
    id         = "hvn"
    region     = "us-east-1"
    cidr_block = "172.25.16.0/10"
  }
  validation {
    condition = contains([
      "us-east-1",
      "us-west-2",
      "eu-west-1",
      "eu-west-2",
      "eu-central-1",
      "ap-southeast-1",
      "ap-southeast-2"
    ], var.hvn.region)
    error_message = "Sorry, hvn.region is not a valid region."
  }
}

variable "connection" {
  type = object({
    id            = string
    type          = string
    tgw_id        = string
    route_id      = string
    attachment_id = string
  })
  description = "(optional) HVN to VPC connection details"
  default = {
    id            = null
    type          = null
    tgw_id        = null
    route_id      = null
    attachment_id = null
  }
  validation {
    condition     = contains(["pcx", "tgw"], var.connection.type)
    error_message = "Sorry, valid values for var: connection.type are ('pcx', 'tgw')."
  }
  validation {
    condition     = var.connection.type == "tgw" && var.connection.tgw_id != null
    error_message = "Sorry, connection.tgw_id must be set if connection.type is 'tgw'."
  }
}

locals {
  peering_connection = var.connection.type == "pcx" ? 1 : 0
  transit_gateway    = var.connection.type == "tgw" ? 1 : 0

  // Define valid HCP HVN regions
  hvn_regions = [
    "us-east-1",
    "us-west-2",
    "eu-west-1",
    "eu-west-2",
    "eu-central-1",
    "ap-southeast-1",
    "ap-southeast-2"
  ]
}