provider "aws" {
  region = var.region
  default_tags {
    tags = {
      Project   = "vpc-peering-intra-region-microservices"
      ManagedBy = "Terraform"
    }
  }
}
