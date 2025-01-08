resource "aws_ecr_repository" "my_python_app" {
  name = "my-python-app"

  tags = {
    Name = "my-python-app"
  }
}

resource "aws_ecr_lifecycle_policy" "my_python_app" {
  repository = aws_ecr_repository.my_python_app.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Remove untagged images"
        selection    = {
          tagStatus    = "untagged"
          countType    = "imageCountMoreThan"
          countNumber  = 10
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}
