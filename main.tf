resource "aws_ecs_cluster" "orchestrator_agent" {
  name = "${var.name}-cluster"

  tags = merge(var.tags, var.default_tags)
}

resource "aws_cloudwatch_log_group" "orchestrator_agent" {
  name = "${var.name}-logs"

  tags = merge(var.tags, var.default_tags)
}

data "aws_region" "current_region" {}
