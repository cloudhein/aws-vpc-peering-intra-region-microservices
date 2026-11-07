data "tfe_outputs" "network" {
  organization = "vpc-peering-intra-region-microservices"
  workspace    = "account-network-ws"
}

locals {
  network = data.tfe_outputs.network.nonsensitive_values
}
