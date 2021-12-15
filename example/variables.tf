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

variable "subnets" {
  description = "A list of subnets that can access the internet and are reachable by instrumented services. The subnets must be in at least 2 different AZs."
  type = list(string)
}

variable "sysdig_access_key" {
  description = "Sysdig access key"
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
