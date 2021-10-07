# Sysdig Orchestrator Agent for ECS Fargate

This Terraform module deploys a Sysdig orchestrator agent for Fargate into a specified VPC.

## Example

The module can be created using the IDs of your VPC and two subnets capable of accessing the internet.

```
module "sysdig_orchestrator_agent" {
  source = "../sysdig-orchestrator-agent"

  name = "test-fargate-orchestrator"

  vpc_id = var.my_vpc_id
  subnet_a = var.my_subnet_a_id
  subnet_b = var.my_subnet_b_id
  access_key = var.my_sysdig_access_key
  assign_public_ip = true  # if using Internet Gateway
}
```

The module outputs can be plugged into the Fargate workload agent data source in the [Sysdig Terraform provider](https://github.com/sysdiglabs/terraform-provider-sysdig):
```
data "sysdig_fargate_workload_agent" "instrumented" {
  ...

  orchestrator_host = module.sysdig_orchestrator_agent.orchestrator_host
  orchestrator_port = module.sysdig_orchestrator_agent.orchestrator_port
}
```

The resulting Terraform plan will have the Sysdig Orchestrator ECS service and a load balancer, as well as instrumented container JSON to use in your ECS Fargate task.
