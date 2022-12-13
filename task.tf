locals {
  access_key_variables = var.access_key != null ? {
    environment_variables = [
      {
        name  = "ACCESS_KEY"
        value = var.access_key
      }
    ]
    secrets = []
    } : {
    environment_variables = []
    secrets = [
      {
        name      = "ACCESS_KEY"
        valueFrom = var.access_key_secret_key_name != null ? "${var.access_key_secret_arn}:${var.access_key_secret_key_name}::" : var.access_key_secret_arn
      }
    ]
  }

  environment = concat(
    local.access_key_variables["environment_variables"],
    [
      {
        name  = "CHECK_CERTIFICATE",
        value = "${var.check_collector_certificate}"
      },
      {
        name  = "COLLECTOR",
        value = "${var.collector_host}"
      },
      {
        name  = "COLLECTOR_PORT",
        value = "${var.collector_port}"
      },
      {
        name  = "TAGS",
        value = "${var.agent_tags}"
      },
      {
        name  = "ADDITIONAL_CONF",
        value = "agentino_port: ${var.orchestrator_port}"
      }
    ]
  )
  secrets = local.access_key_variables["secrets"]
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
    orchestrator_port = var.orchestrator_port
    awslogs_region    = data.aws_region.current_region.name
    awslogs_group     = "${var.name}-logs"
    environment       = local.environment
    secrets           = local.secrets
    }
  )

  tags = merge(var.tags, var.default_tags)
}
