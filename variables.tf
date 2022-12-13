#
# Required variables
#
variable "name" {
  description = "Identifier for module resources"
  type        = string
  default     = "sysdig-fargate-orchestrator"
}

variable "vpc_id" {
  description = "ID of the VPC where the orchestrator should be installed"
  type        = string
}

variable "subnets" {
  description = "A list of subnets that can access the internet and are reachable by instrumented services. The subnets must be in at least 2 different AZs."
  type        = list(string)
}

variable "access_key" {
  description = "Sysdig access key. Either var.access_key or var.access_key_secret_name and var.access_key_secret_arn must be set."
  type        = string
}

variable "access_key_secret_key_name" {
  description = "The key name in Sysdig access key secret. Either var.access_key or var.access_key_secret_name and var.access_key_secret_arn must be set. If var.access_key_secret_key_name is null and var.access_key_secret_arn is set, the secret value itself is used."
  type        = string
  default     = null
}

variable "access_key_secret_arn" {
  description = "Sysdig access key secret arn. Either var.access_key or var.access_key_secret_name and var.access_key_secret_arn must be set."
  type        = string
  default     = null
}

#
# Optional variables
#
variable "orchestrator_port" {
  description = "Port for the workload agent to connect"
  type        = number
  default     = 6667
}

variable "agent_image" {
  description = "Orchestrator agent image"
  type        = string
  default     = "quay.io/sysdig/orchestrator-agent:latest"
}

variable "collector_host" {
  description = "Sysdig collector host"
  type        = string
  default     = "collector.sysdigcloud.com"
}

variable "collector_port" {
  description = "Sysdig collector port"
  type        = string
  default     = "6443"
}

variable "agent_tags" {
  description = "Comma separated list of tags for this agent"
  type        = string
  default     = ""
}

variable "check_collector_certificate" {
  description = "Whether to check the collector certificate when connecting. Mainly for development."
  type        = string
  default     = "true"
}

variable "assign_public_ip" {
  description = "Provisions a public IP for the service. Required when using an Internet Gateway for egress."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Extra tags for all Sysdig Fargate Orchestrator resources"
  type        = map(string)
  default     = {}
}

variable "default_tags" {
  description = "Default tags for all Sysdig Fargate Orchestrator resources"
  type        = map(string)
  default = {
    Application = "sysdig"
    Module      = "fargate-orchestrator-agent"
  }
}
