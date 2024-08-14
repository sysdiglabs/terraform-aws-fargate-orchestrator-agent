output "orchestrator_host" {
  description = "The DNS name of the orchestrator's load balancer"
  value       = aws_lb.orchestrator_agent.dns_name
}

output "orchestrator_port" {
  description = "The configured port on the orchestrator"
  value       = var.orchestrator_port
}

output "orchestrator_security_group_id" {
  description = "The security group ID of the orchestrator LB."
  value       = aws_security_group.orchestrator_agent.id
}
