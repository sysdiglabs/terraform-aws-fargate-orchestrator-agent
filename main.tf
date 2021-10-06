resource "aws_ecs_cluster" "orchestrator_agent" {
  name = "${var.name}-cluster"
}

resource "aws_cloudwatch_log_group" "orchestrator_agent" {
  name = "${var.name}-logs"
}

data "template_file" "agent_container_definitions" {
  template = file("${path.module}/container-definitions/orchestrator-agent.json")

  vars = {
    agent_image = var.agent_image
    access_key = var.access_key
    collector_host = var.collector_host
    collector_port = var.collector_port
    agent_tags = var.agent_tags
    check_certificate = var.check_collector_certificate
    orchestrator_port = var.orchestrator_port
    awslogs_region = data.aws_region.current_region.name
    awslogs_group = "${var.name}-logs"
  }
}

data "aws_region" "current_region" {}
