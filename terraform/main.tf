# OIDC Provider for GitHub Actions
resource "aws_iam_openid_connect_provider" "github_oidc" {
  url = "https://token.actions.githubusercontent.com"
  client_id_list = [
    "sts.amazonaws.com"
  ]
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]
}

# IAM Role for GitHub Actions
resource "aws_iam_role" "github_actions_role" {
  name = "github-actions-role"

  assume_role_policy = data.aws_iam_policy_document.github_oidc_assume_role.json
}

# IAM Policy for Elastic Beanstalk Deployment
resource "aws_iam_policy" "github_actions_policy" {
  policy = data.aws_iam_policy_document.github_actions_policy.json
}

# Attach Policy to IAM Role
resource "aws_iam_role_policy_attachment" "github_actions_policy_attachment" {
  role       = aws_iam_role.github_actions_role.name
  policy_arn = aws_iam_policy.github_actions_policy.arn
}

# Trust Relationship Policy for OIDC
data "aws_iam_policy_document" "github_oidc_assume_role" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github_oidc.arn]
    }

    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values = [
        "repo:abid-madetech/create-api-practice:*" 
      ]
    }
  }
}

# Policy for Elastic Beanstalk and Related Services
data "aws_iam_policy_document" "github_actions_policy" {
  statement {
    actions = [
      "elasticbeanstalk:*",
      "s3:*",
      "cloudwatch:*",
      "logs:*"
    ]
    resources = ["*"]
  }
}
