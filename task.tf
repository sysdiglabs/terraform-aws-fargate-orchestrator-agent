resource "aws_ecs_task_definition" "orchestrator_agent" {
  family = "${var.name}-orchestrator-agent"
  task_role_arn = "${aws_iam_role.agent_task_role.arn}"
  execution_role_arn = "${aws_iam_role.agent_execution_role.arn}"
  network_mode = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu = "2048"
  memory = "8GB"
  container_definitions = data.template_file.agent_container_definitions.rendered
}
