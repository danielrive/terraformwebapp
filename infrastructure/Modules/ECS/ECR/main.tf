#***  ECR Resource *****

# ---- ECR repository ----
resource "aws_ecr_repository" "ECR_REPOSITORY" {
  name = "${var.ENVIRONMENT}"
}


# ----Policy fot the repository ----
resource "aws_ecr_repository_policy" "ECR_REPOSITORY_POLICY" {
  repository = "${aws_ecr_repository.ECR_REPOSITORY.name}"

  policy = <<EOF
{
    "Version": "2008-10-17",
    "Statement": [
        {
            "Sid": "new statement",
            "Effect": "Allow",
            "Principal": {
                "AWS": [
                    "arn:aws:iam::${var.ACCOUNT_NAME}:root"
                ]
            },
            "Action": [
                "ecr:GetDownloadUrlForLayer",
                "ecr:BatchGetImage",
                "ecr:BatchCheckLayerAvailability",
                "ecr:PutImage",
                "ecr:InitiateLayerUpload",
                "ecr:UploadLayerPart",
                "ecr:CompleteLayerUpload",
                "ecr:ListImages"
            ]
        }
    ]
}
EOF
}

