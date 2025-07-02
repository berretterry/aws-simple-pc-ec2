
resource "aws_iam_role" "this_task_execution" {
  name_prefix = "${local.name}-"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      },
    ]
  })

}

resource "aws_iam_policy" "this_task_execution" {
  name_prefix = "${local.name}-"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:BatchGetImage",
          "ecr:GetDownloadUrlForLayer",
          "ecr:GetAuthorizationToken",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
        ]
        Resource = "*"
      },

      {
        Action = [
          "secretsmanager:GetSecretValue",
          "ssm:GetParameter*",
          "kms:Decrypt"
        ]
        Effect = "Allow"
        Resource = [
          "${aws_ssm_parameter.secret_key.arn}",
          "arn:aws:ssm:us-west-2:637423342822:parameter/*",
          "arn:aws:secretsmanager:us-west-2:637423342822:secret:*",
          "arn:aws:kms:us-west-2:637423342822:key/*"
        ],
      },
    ]
  })

}

resource "aws_iam_role_policy_attachment" "this_task_execution" {
  role       = aws_iam_role.this_task_execution.name
  policy_arn = aws_iam_policy.this_task_execution.arn
}

# ==========

resource "aws_iam_role" "this_task" {
  name_prefix = "${local.name}-"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_policy" "this_task" {
  name_prefix = "${local.name}-"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "ExecuteCommand"
        Effect = "Allow"
        Action = [
          "ssmmessages:CreateControlChannel",
          "ssmmessages:CreateDataChannel",
          "ssmmessages:OpenControlChannel",
          "ssmmessages:OpenDataChannel",
        ]
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "this_task" {
  role       = aws_iam_role.this_task.name
  policy_arn = aws_iam_policy.this_task.arn
}

