output "app_security_group_id" {
  value = aws_security_group.app.id
}

output "alb_security_group_id" {
  value = aws_security_group.alb.id
}

# output "instance_profile_name" {
#   value = aws_iam_instance_profile.app.name
# }

# output "app_role_arn" {
#   value = aws_iam_role.app.arn
# }
