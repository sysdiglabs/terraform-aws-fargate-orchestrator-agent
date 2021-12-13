resource "aws_ecs_task_definition" "orchestrator_agent" {
  family = "${var.name}-orchestrator-agent"
  task_role_arn = "${aws_iam_role.orchestrator_agent_task_role.arn}"
  execution_role_arn = "${aws_iam_role.orchestrator_agent_execution_role.arn}"
  network_mode = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu = "2048"
  memory = "8192"
  container_definitions = data.template_file.orchestrator_agent_container_definitions.rendered

  tags = merge(var.tags, var.default_tags)
}
