resource "aws_lb" "orchestrator_agent" {
  internal = true
  load_balancer_type = "network"
  ip_address_type = "ipv4"
  subnets = var.subnets

  tags = merge(var.tags, var.default_tags)
}

resource "aws_lb_target_group" "orchestrator_agent" {
  port = var.orchestrator_port
  protocol = "TCP"
  target_type = "ip"
  deregistration_delay = 60
  vpc_id = var.vpc_id

  tags = merge(var.tags, var.default_tags)
}

resource "aws_lb_listener" "orchestrator_agent" {
  load_balancer_arn = aws_lb.orchestrator_agent.arn
  port = var.orchestrator_port
  protocol = "TCP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.orchestrator_agent.arn
  }

  tags = merge(var.tags, var.default_tags)
}
