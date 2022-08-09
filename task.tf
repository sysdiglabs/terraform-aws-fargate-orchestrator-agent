resource "aws_ecs_task_definition" "orchestrator_agent" {
  family = "${var.name}-orchestrator-agent"
  task_role_arn = "${aws_iam_role.orchestrator_agent_task_role.arn}"
  execution_role_arn = "${aws_iam_role.orchestrator_agent_execution_role.arn}"
  network_mode = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu = "2048"
  memory = "8192"

  container_definitions = templatefile("${path.module}/container-definitions/orchestrator-agent.json", {
    agent_image = var.agent_image
    access_key = var.access_key
    collector_host = var.collector_host
    collector_port = var.collector_port
    agent_tags = var.agent_tags
    check_certificate = var.check_collector_certificate
    orchestrator_port = var.orchestrator_port
    awslogs_region = data.aws_region.current_region.name
    awslogs_group = "${var.name}-logs"
  })

  tags = merge(var.tags, var.default_tags)
}
