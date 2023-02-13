locals {
  secret_reference_access_key = local.do_fetch_secret_access_key ? split(":", var.access_key) : []
  secret_reference_http_proxy_password = local.do_fetch_secret_http_proxy_password ? split(":", var.http_proxy_configuration.proxy_password) : []
}

resource "aws_iam_role" "orchestrator_agent_execution_role" {
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json

  managed_policy_arns = ["arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"]

  dynamic "inline_policy" {
    for_each = local.do_fetch_secret_access_key ? ["SecretsManagerAccessKey"] : []
    content {
      name = "SysdigGetSecretAccessKey"
      policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
          {
            Action = [
              "secretsmanager:GetSecretValue",
            ]
            Effect = "Allow"
            Resource = [format("arn:aws:secretsmanager:%s:%s:secret:%s",
              element(local.secret_reference_access_key, 3),
              element(local.secret_reference_access_key, 4),
              element(local.secret_reference_access_key, 6)
              )
            ]
          },
        ]
      })
    }
  }

  dynamic "inline_policy" {
    for_each = local.do_fetch_secret_http_proxy_password ? ["SysdigGetSecretHttpProxyPassword"] : []
    content {
      name = "SysdigGetSecretHttpProxyPassword"
      policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
          {
            Action = [
              "secretsmanager:GetSecretValue",
            ]
            Effect = "Allow"
            Resource = [format("arn:aws:secretsmanager:%s:%s:secret:%s",
              element(local.secret_reference_http_proxy_password, 3),
              element(local.secret_reference_http_proxy_password, 4),
              element(local.secret_reference_http_proxy_password, 6)
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
