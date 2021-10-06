variable "name" {
  description = "Identifier to tag all resources"
  type = string
  default = ""
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
  default = ""
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
  description = ""
  type = string
  default = "true"
}

variable "subnet_a" {
  description = ""
  type = string
  default = ""
}

variable "subnet_b" {
  description = ""
  type = string
  default = ""
}

variable "assign_public_ip" {
  description = ""
  type = bool
  default = false
}
