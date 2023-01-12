locals {
  access_key_secretsmanager_reference = startswith(var.access_key, "arn:aws:secretsmanager:") ? [split(":", var.access_key)] : []
}

locals {
  secrets = local.do_fetch_secret ? [
    {
      name      = "ACCESS_KEY",
      valueFrom = var.access_key
    }
  ] : []

  environment = concat(
    local.do_fetch_secret ? [] : [
      {
        name  = "ACCESS_KEY",
        value = var.access_key
      }
    ],
    [
      {
        name  = "CHECK_CERTIFICATE",
        value = var.check_collector_certificate
      },
      {
        name  = "COLLECTOR",
        value = var.collector_host
      },
      {
        name  = "COLLECTOR_PORT",
        value = var.collector_port
      },
      {
        name  = "TAGS",
        value = var.agent_tags
      },
      {
        name  = "ADDITIONAL_CONF",
        value = format("agentino_port: %s", tostring(var.orchestrator_port))
      }
    ]
  )
}

resource "aws_ecs_task_definition" "orchestrator_agent" {
  family                   = "${var.name}-orchestrator-agent"
  task_role_arn            = aws_iam_role.orchestrator_agent_task_role.arn
  execution_role_arn       = aws_iam_role.orchestrator_agent_execution_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "2048"
  memory                   = "8192"

  container_definitions = templatefile("${path.module}/container-definitions/orchestrator-agent.json", {
    agent_image       = var.agent_image
    awslogs_region    = data.aws_region.current_region.name
    awslogs_group     = "${var.name}-logs"
    orchestrator_port = var.orchestrator_port
    secrets           = local.secrets
    environment       = local.environment
  })

  tags = merge(var.tags, var.default_tags)
}
