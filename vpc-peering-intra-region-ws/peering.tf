# Customer VPC <-> Account VPC

resource "aws_vpc_peering_connection" "customer_account" {
  vpc_id      = local.customer_network.vpc_id
  peer_vpc_id = local.account_network.vpc_id
  auto_accept = true

  requester {
    allow_remote_vpc_dns_resolution = true
  }

  accepter {
    allow_remote_vpc_dns_resolution = true
  }

  tags = {
    Name = "microservices-customer_account"
  }
}

# Account VPC <-> Statement VPC

resource "aws_vpc_peering_connection" "account_statement" {
  vpc_id      = local.account_network.vpc_id
  peer_vpc_id = local.statement_network.vpc_id
  auto_accept = true

  requester {
    allow_remote_vpc_dns_resolution = true
  }

  accepter {
    allow_remote_vpc_dns_resolution = true
  }

  tags = {
    Name = "microservices-account_statement"
  }
}
