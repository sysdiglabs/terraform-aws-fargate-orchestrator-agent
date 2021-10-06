resource "aws_security_group" "orchestrator_agent" {
  name = "${var.name}"
  description = "Allow agentino to connect"
  vpc_id = var.vpc_id
}

resource "aws_security_group_rule" "agent_ingress_rule" {
  type = "ingress"
  protocol = "tcp"
  from_port = var.orchestrator_port
  to_port = var.orchestrator_port
  cidr_blocks = [ "0.0.0.0/0" ]
  security_group_id = aws_security_group.orchestrator_agent.id
}

resource "aws_security_group_rule" "agent_egress_rule" {
  type = "egress"
  protocol = "all"
  from_port = 0
  to_port = 0
  cidr_blocks = [ "0.0.0.0/0" ]
  security_group_id = aws_security_group.orchestrator_agent.id
}
