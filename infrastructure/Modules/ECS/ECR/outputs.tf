#### Outputs ECR ####

output "Repo_URL" {
    value = aws_ecr_repository.ECR_REPOSITORY.repository_url 
}
