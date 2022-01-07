variable "hvn_region" {
  type        = string
  description = "The AWS region where you want to deploy your HCP clusters."
  default     = "us-east-1"
}

variable "example" {
  type        = string
  description = "The value which will be passed to the example module"
}
