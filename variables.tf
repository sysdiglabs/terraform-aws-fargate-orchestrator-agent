#
# Required variables
#
variable "name" {
  description = "Identifier for module resources"
  type = string
  default = "sysdig-fargate-orchestrator"
}

variable "vpc_id" {
  description = "ID of the VPC where the orchestrator should be installed"
  type = string
}

variable "access_key" {
  description = "Sysdig access key"
  type = string
}

variable "subnet_a" {
  description = "A subnet that can access internet and is reachable by instrumented services. This must be in a different AZ for HA."
  type = string
}

variable "subnet_b" {
  description = "A subnet that can access internet and is reachable by instrumented services. This must be in a different AZ for HA."
  type = string
}

#
# Optional variables
#
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

variable "assign_public_ip" {
  description = "Provisions a public IP for the service. Required when using an Internet Gateway for egress."
  type = bool
  default = false
}

variable "tags" {
  description = "Extra tags for all Sysdig Fargate Orchestrator resources"
  type = map(string)
  default = {}
}

variable "default_tags" {
  description = "Default tags for all Sysdig Fargate Orchestrator resources"
  type = map(string)
  default = {
    Application = "sysdig"
    Module = "fargate-orchestrator-agent"
  }
}
