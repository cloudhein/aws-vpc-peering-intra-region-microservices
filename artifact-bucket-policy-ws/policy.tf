locals {
  artifacts_bucket = data.tfe_outputs.customer_network.nonsensitive_values.artifacts_bucket

  s3_endpoint_ids = [
    data.tfe_outputs.customer_network.nonsensitive_values.s3_endpoint_id,
    data.tfe_outputs.account_network.nonsensitive_values.s3_endpoint_id,
    data.tfe_outputs.statement_network.nonsensitive_values.s3_endpoint_id,
  ]
}

resource "aws_s3_bucket_policy" "artifacts" {
  bucket = local.artifacts_bucket

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowGetObjectThroughServiceEndpoints"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "arn:aws:s3:::${local.artifacts_bucket}/*"

        Condition = {
          StringEquals = {
            "aws:SourceVpce" = local.s3_endpoint_ids
          }
          Bool = {
            "aws:SecureTransport" = "true"
          }
        }
      },
      {
        Sid       = "AllowListBucketThroughServiceEndpoints"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:ListBucket"
        Resource  = "arn:aws:s3:::${local.artifacts_bucket}"

        Condition = {
          StringEquals = {
            "aws:SourceVpce" = local.s3_endpoint_ids
          }
          Bool = {
            "aws:SecureTransport" = "true"
          }
        }
      }
    ]
  })
}