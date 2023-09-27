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

resource "aws_appautoscaling_target" "autoscaling_target" {
  // Deploy this resource conditionally
  count = local.enable_autoscaling ? 1 : 0

  max_capacity       = var.autoscaling.max_capacity
  min_capacity       = 1
  resource_id        = "service/${aws_ecs_cluster.orchestrator_agent.name}/${aws_ecs_service.orchestrator_agent.name}"
  role_arn           = aws_iam_role.orchestrator_agent_autoscaling[0].arn
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace = "ecs"
}

resource "aws_appautoscaling_policy" "autoscaling_policy" {
  // Deploy this resource conditionally
  count = local.enable_autoscaling ? 1 : 0

  name               = "${var.name}-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.autoscaling_target[0].resource_id
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace = "ecs"

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = var.autoscaling.target_metric
    }
    target_value = var.autoscaling.target_value
    scale_in_cooldown = var.autoscaling.scale_in_cooldown
    scale_out_cooldown = var.autoscaling.scale_out_cooldown
  }
}
