variable "name" {
  description = "Identifier to tag all resources"
  type = string
  default = "sysdig-fargate-orchestrator"
}

variable "vpc_id" {
  description = "ID of the VPC where the orchestrator should be installed"
  type = string
}

variable "orchestrator_port" {
  description = "Port for the workload agent to connect"
  type = number
  default = 6667
}

variable "agent_image" {
  description = "Orchestrator agent image"
  type = string
  default = "quay.io/sysdig/orchestrator-agent:latest"
}

variable "access_key" {
  description = "Sysdig access key"
  type = string
}

variable "collector_host" {
  description = "Sysdig collector host"
  type = string
  default = "collector.sysdigcloud.com"
}

variable "collector_port" {
  description = "Sysdig collector port"
  type = string
  default = "6443"
}

variable "agent_tags" {
  description = "Comma separated list of tags for this agent"
  type = string
  default = ""
}

variable "check_collector_certificate" {
  description = "Whether to check the collector certificate when connecting. Mainly for development."
  type = string
  default = "true"
}

variable "subnet_a" {
  description = "First subnet in VPC"
  type = string
}

variable "subnet_b" {
  description = "Second subnet in VPC"
  type = string
}

variable "assign_public_ip" {
  description = "Provisions a public IP for the service. Required when using an Internet Gateway for egress."
  type = bool
  default = false
}
