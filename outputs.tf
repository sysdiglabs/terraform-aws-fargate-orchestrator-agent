output "orchestrator_host" {
  description = "The DNS name of the orchestrator's load balancer"
  value       = aws_lb.orchestrator_agent.dns_name
}

output "orchestrator_port" {
  description = "The configured port on the orchestrator"
  value       = var.orchestrator_port
}
