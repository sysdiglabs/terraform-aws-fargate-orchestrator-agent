resource "aws_ecs_service" "orchestrator_agent" {
  name             = "OrchestratorAgent"
  cluster          = aws_ecs_cluster.orchestrator_agent.id
  task_definition  = aws_ecs_task_definition.orchestrator_agent.arn
  desired_count    = 1
  launch_type      = "FARGATE"
  platform_version = "1.4.0"
  depends_on       = [aws_lb_listener.orchestrator_agent]

  load_balancer {
    target_group_arn = aws_lb_target_group.orchestrator_agent.arn
    container_name   = "OrchestratorAgent"
    container_port   = var.orchestrator_port
  }

  network_configuration {
    subnets = var.subnets

    security_groups = [aws_security_group.orchestrator_agent.id]

    assign_public_ip = var.assign_public_ip
  }

  tags = merge(var.tags, var.default_tags)
}
