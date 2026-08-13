output "ec2_instance_profile_name" { value = aws_iam_instance_profile.ec2.name }
output "github_actions_role_arn" { value = try(aws_iam_role.github[0].arn, null) }

