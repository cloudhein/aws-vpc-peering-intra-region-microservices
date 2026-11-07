# Rules are grouped by the security group they belong to.
# Cross-VPC rules remain in vpc-peering-intra-region-ws/security.tf.
# All rules are standalone; no allow-all egress rule is added.

# Account ALB security group and its ingress/egress rules

# Create the Account ALB security group.
resource "aws_security_group" "alb" {
  name        = "microservices-account-alb"
  description = "account ALB: only approved clients and app targets"
  vpc_id      = local.network.vpc_id
}

# Egress: send requests and health checks to the Account app on port 9090.
resource "aws_vpc_security_group_egress_rule" "alb_to_app" {
  security_group_id            = aws_security_group.alb.id
  referenced_security_group_id = aws_security_group.app.id
  ip_protocol                  = "tcp"
  from_port                    = 9090
  to_port                      = 9090
}


# Account app security group and its ingress/egress rules

# Create the Account application security group.
resource "aws_security_group" "app" {
  name        = "microservices-account-app"
  description = "account application: least privilege"
  vpc_id      = local.network.vpc_id
}

# Ingress: accept requests and health checks from the Account ALB on port 9090.
resource "aws_vpc_security_group_ingress_rule" "app_from_alb" {
  security_group_id            = aws_security_group.app.id
  referenced_security_group_id = aws_security_group.alb.id
  ip_protocol                  = "tcp"
  from_port                    = 9090
  to_port                      = 9090
  description                  = "Application requests and health checks"
}

# Egress: download this service binary from S3 over HTTPS on port 443.
resource "aws_vpc_security_group_egress_rule" "app_to_s3" {
  security_group_id = aws_security_group.app.id
  prefix_list_id    = local.network.s3_prefix_list_id
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443
  description       = "Artifact download over the local S3 gateway endpoint"
}


# EC2 identity and S3 artifact permissions

# Allow EC2 to assume the application role.
# resource "aws_iam_role" "app" {
#   name = "microservices-account-app"
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [{
#       Effect    = "Allow"
#       Principal = { Service = "ec2.amazonaws.com" }
#       Action    = "sts:AssumeRole"
#     }]
#   })
# }

# # Allow this role to read its binary over TLS through its own S3 endpoint.
# resource "aws_iam_role_policy" "artifact" {
#   name = "read-own-artifact-through-own-endpoint"
#   role = aws_iam_role.app.id
#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [{
#       Effect   = "Allow"
#       Action   = "s3:GetObject"
#       Resource = "arn:aws:s3:::${local.network.artifacts_bucket}/${local.network.artifact_key}"
#       Condition = {
#         StringEquals = { "aws:SourceVpce" = local.network.s3_endpoint_id }
#         Bool         = { "aws:SecureTransport" = "true" }
#       }
#     }]
#   })
# }

# # Attach the application role to EC2 through an instance profile.
# resource "aws_iam_instance_profile" "app" {
#   name       = "microservices-account-app"
#   role       = aws_iam_role.app.name
#   depends_on = [aws_iam_role_policy.artifact]
# }
