variable "region" {
  description = "All workspaces and the artifact bucket must use this same AWS Region."
  type        = string
  default     = "ap-southeast-1"
}

# variable "existing_artifacts_bucket_policy_json" {
#   description = "Existing bucket policy to preserve when this workspace takes ownership. Import any existing policy first."
#   type        = string
#   default     = null
#   validation {
#     condition     = var.existing_artifacts_bucket_policy_json == null ? true : can(jsondecode(var.existing_artifacts_bucket_policy_json).Statement)
#     error_message = "Provide a JSON IAM policy document containing Statement, or null."
#   }
# }

