#
# Required variables
#
variable "name" {
  description = "Identifier for module resources"
  type = string
}

variable "vpc_id" {
  description = "ID of the VPC where the orchestrator should be installed"
  type = string
}

variable "subnet_a" {
  description = "First subnet in VPC"
  type = string
}

variable "subnet_b" {
  description = "A subnet that can access internet and is reachable by instrumented services. This must be in a different AZ for HA."
  type = string
}

variable "sysdig_access_key" {
  description = "A subnet that can access internet and is reachable by instrumented services. This must be in a different AZ for HA."
  type = string
}

#
# Optional variables
#
variable "sysdig_workload_agent_image" {
  description = "Workload agent image"
  type = string
  default = "quay.io/sysdig/workload-agent:latest"
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
