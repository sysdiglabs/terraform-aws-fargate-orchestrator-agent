locals {
  secret_reference = local.do_fetch_secret ? split(":", var.access_key) : []
}

resource "aws_iam_role" "orchestrator_agent_execution_role" {
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json

  managed_policy_arns = ["arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"]

  dynamic "inline_policy" {
    for_each = local.do_fetch_secret ? ["SecretsManagerAccessKey"] : []
    content {
      name = "root"
      policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
          {
            Action = [
              "secretsmanager:GetSecretValue",
            ]
            Effect = "Allow"
            Resource = [format("arn:aws:secretsmanager:%s:%s:secret:%s",
              element(local.secret_reference, 3),
              element(local.secret_reference, 4),
              element(local.secret_reference, 6)
              )
            ]
          },
        ]
      })
    }
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
