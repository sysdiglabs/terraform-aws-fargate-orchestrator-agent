resource "aws_iam_role" "orchestrator_agent_execution_role" {
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json

  managed_policy_arns = ["arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"]

  tags = merge(var.tags, var.default_tags)
}

resource "aws_iam_role" "orchestrator_agent_task_role" {
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json

  inline_policy {
    name   = "root"
    policy = data.aws_iam_policy_document.task_policy.json
  }

  tags = merge(var.tags, var.default_tags)
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "task_policy" {
  statement {
    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = ["*"]
  }

  dynamic "statement" {
    for_each = var.access_key_secret_arn != null ? ["once"] : []
    content {
      sid       = "SecretsAccess"
      effect    = "Allow"
      actions   = ["secretsmanager:GetSecretValue"]
      resources = [var.access_key_secret_arn]
    }
  }
}
