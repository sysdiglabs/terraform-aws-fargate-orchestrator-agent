# Sysdig Orchestrator Agent for ECS Fargate

This Terraform module deploys a Sysdig orchestrator agent for Fargate into a specified VPC.

## Example

The module can be created using the IDs of your VPC and two subnets capable of accessing the internet.

```
module "fargate-orchestrator-agent" {
  source = "../terraform-aws-fargate-orchestrator-agent"

  name = "test-fargate-orchestrator"

  vpc_id = var.my_vpc_id
  subnets = [var.my_subnet_a_id, var.my_subnet_b_id]
  access_key = var.my_sysdig_access_key
  assign_public_ip = true  # if using Internet Gateway
}
```

The module outputs can be plugged into the Fargate workload agent data source in the [Sysdig Terraform provider](https://github.com/sysdiglabs/terraform-provider-sysdig):
```
data "sysdig_fargate_workload_agent" "instrumented" {
  ...

  orchestrator_host = module.fargate-orchestrator-agent.orchestrator_host
  orchestrator_port = module.fargate-orchestrator-agent.orchestrator_port
}
```

The resulting Terraform plan will have the Sysdig Orchestrator ECS service and a load balancer, as well as instrumented container JSON to use in your ECS Fargate task.

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name                                              | Version |
|---------------------------------------------------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 3.61.0  |

## Modules

No modules.

## Resources and Data Sources

| Name                                                                                                                                                                | Type        |
|---------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------------|
| [aws_cloudwatch_log_group.orchestrator_agent](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group)                     | resource    |
| [aws_ecs_cluster.orchestrator_agent](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster)                                       | resource    |
| [aws_ecs_service.orchestrator_agent](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service)                                       | resource    |
| [aws_ecs_task_definition.orchestrator_agent](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition)                       | resource    |
| [aws_iam_role.orchestrator_agent_execution_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role)                              | resource    |
| [aws_lb.orchestrator_agent](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb)                                                         | resource    |
| [aws_lb_listener.orchestrator_agent](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener)                                       | resource    |
| [aws_lb_target_group.orchestrator_agent](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group)                               | resource    |
| [aws_security_group.orchestrator_agent](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group)                                 | resource    |
| [aws_security_group_rule.orchestrator_agent_egress_rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule)           | resource    |
| [aws_security_group_rule.orchestrator_agent_ingress_rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule)          | resource    |
| [aws_region.current_region](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region)                                                  | data source |

## Inputs

| Name                                                                                                                                                                             | Description                                                                                                                                                                                                                                         | Type           | Default                                                                                     | Required |
|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------------|---------------------------------------------------------------------------------------------|:--------:|
| <a name="input_access_key"></a> [access\_key](#input\_access\_key)                                                                                                               | Sysdig Access Key as either clear text or SecretsManager-backed secret reference (expected pattern: `arn:aws:secretsmanager:region:accountId:secret:secretName[:jsonKey:versionStage:versionId]`)                                                   | `string`       | n/a                                                                                         |   yes    |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id)                                                                                                                           | ID of the VPC where the orchestrator should be installed                                                                                                                                                                                            | `string`       | n/a                                                                                         |   yes    |
| <a name="input_subnets"></a> [subnets](#input\_subnets)                                                                                                                          | A list of subnets that can access the internet and are reachable by instrumented services. The subnets must be in at least 2 different AZs.                                                                                                         | `list(string)` | n/a                                                                                         |   yes    |
| <a name="input_agent_image"></a> [agent\_image](#input\_agent\_image)                                                                                                            | Orchestrator agent image                                                                                                                                                                                                                            | `string`       | `"quay.io/sysdig/orchestrator-agent:latest"`                                                |    no    |
| <a name="input_agent_tags"></a> [agent\_tags](#input\_agent\_tags)                                                                                                               | Comma separated list of tags for this agent                                                                                                                                                                                                         | `string`       | `""`                                                                                        |    no    |
| <a name="input_assign_public_ip"></a> [assign\_public\_ip](#input\_assign\_public\_ip)                                                                                           | Provisions a public IP for the service. Required when using an Internet Gateway for egress.                                                                                                                                                         | `bool`         | `false`                                                                                     |    no    |
| <a name="input_check_collector_certificate"></a> [check\_collector\_certificate](#input\_check\_collector\_certificate)                                                          | Whether to check the collector certificate when connecting. Mainly for development.                                                                                                                                                                 | `string`       | `"true"`                                                                                    |    no    |
| <a name="input_collector_host"></a> [collector\_host](#input\_collector\_host)                                                                                                   | Sysdig collector host                                                                                                                                                                                                                               | `string`       | `"collector.sysdigcloud.com"`                                                               |    no    |
| <a name="input_collector_port"></a> [collector\_port](#input\_collector\_port)                                                                                                   | Sysdig collector port                                                                                                                                                                                                                               | `string`       | `"6443"`                                                                                    |    no    |
| <a name="input_default_tags"></a> [default\_tags](#input\_default\_tags)                                                                                                         | Default tags for all Sysdig Fargate Orchestrator resources                                                                                                                                                                                          | `map(string)`  | <pre>{<br>  "Application": "sysdig",<br>  "Module": "fargate-orchestrator-agent"<br>}</pre> |    no    |
| <a name="input_name"></a> [name](#input\_name)                                                                                                                                   | Identifier for module resources                                                                                                                                                                                                                     | `string`       | `"sysdig-fargate-orchestrator"`                                                             |    no    |
| <a name="input_orchestrator_port"></a> [orchestrator\_port](#input\_orchestrator\_port)                                                                                          | Port for the workload agent to connect                                                                                                                                                                                                              | `number`       | `6667`                                                                                      |    no    |
| <a name="input_tags"></a> [tags](#input\_tags)                                                                                                                                   | Extra tags for all Sysdig Fargate Orchestrator resources                                                                                                                                                                                            | `map(string)`  | `{}`                                                                                        |    no    |
| <a name="input_collector_ca_certificate_type"></a> [collector\_ca\_certificate.type](#collector\_ca\_certificate.type)                                                           | Uploads the collector custom CA certificate - The value type                                                                                                                                                                                        | `string`       | `"base64"`                                                                                  |    no    |
| <a name="input_collector_ca_certificate_value"></a> [collector\_ca\_certificate.value](#collector\_ca\_certificate.value)                                                        | Uploads the collector custom CA certificate - The value of the CA Certificate                                                                                                                                                                       | `string`       | `""`                                                                                        |    no    |
| <a name="input_collector_ca_certificate_path"></a> [collector\_ca\_certificate.path](#collector\_ca\_certificate.path)                                                           | Uploads the collector custom CA certificate - The path to the CA certificate in the orchestrator                                                                                                                                                    | `string`       | `"/ssl/collector_cert.pm"`                                                                  |    no    |
| <a name="input_collector_configuration_ca_certificate"></a> [collector\_configuration.ca\_certificate](#collector\_configuration.ca\_certificate)                                | Configures the SSL connection to the collector - The path to the CA certificate to use in the SSL connection to the collector                                                                                                                       | `string`       | `""`                                                                                        |    no    |
| <a name="input_http_proxy_ca_certificate_type"></a> [http\_proxy\_ca\_certificate.type](#http\_proxy\_ca\_certificate.type)                                                      | Uploads the HTTP proxy CA certificate - The value type                                                                                                                                                                                              | `string`       | `"base64"`                                                                                  |    no    |
| <a name="input_http_proxy_ca_certificate_value"></a> [http\_proxy\_ca\_certificate.value](#http\_proxy\_ca\_certificate.value)                                                   | Uploads the HTTP proxy CA certificate - The value of the CA Certificate                                                                                                                                                                             | `string`       | `""`                                                                                        |    no    |
| <a name="input_http_proxy_ca_certificate_path"></a> [http\_proxy\_ca\_certificate.path](#http\_proxy\_ca\_certificate.path)                                                      | Uploads the HTTP proxy CA certificate - The path to the CA certificate in the orchestrator                                                                                                                                                          | `string`       | `"/ssl/proxy_cert.pm"`                                                                      |    no    |
| <a name="input_http_proxy_configuration_proxy_host"></a> [http\_proxy\_configuration.proxy\_host](#http\_proxy\_configuration.proxy\_host)                                       | Configures the SSL connection to the HTTP proxy - The proxy host                                                                                                                                                                                    | `string`       | `""`                                                                                        |    no    |
| <a name="input_http_proxy_configuration_proxy_port"></a> [http\_proxy\_configuration.proxy\_port](#http\_proxy\_configuration.proxy\_port)                                       | Configures the SSL connection to the HTTP proxy - The proxy port                                                                                                                                                                                    | `string`       | `""`                                                                                        |    no    |
| <a name="input_http_proxy_configuration_proxy_user"></a> [http\_proxy\_configuration.proxy\_user](#http\_proxy\_configuration.proxy\_user)                                       | Configures the SSL connection to the HTTP proxy - The proxy user                                                                                                                                                                                    | `string`       | `""`                                                                                        |    no    |
| <a name="input_http_proxy_configuration_proxy_password"></a> [http\_proxy\_configuration.proxy\_password](#http\_proxy\_configuration.proxy\_password)                           | Configures the SSL connection to the HTTP proxy - The proxy password as either clear text or SecretsManage-backed secret reference (expected pattern: `arn:aws:secretsmanager:region:accountId:secret:secretName[:jsonKey:versionStage:versionId]`) | `string`       | `""`                                                                                        |    no    |
| <a name="input_http_proxy_configuration_ssl"></a> [http\_proxy\_configuration.ssl](#http\_proxy\_configuration.ssl)                                                              | Configures the SSL connection to the HTTP proxy - Enables/disables SSL encryption                                                                                                                                                                   | `string`       | `""`                                                                                        |    no    |
| <a name="input_http_proxy_configuration_ssl_verify_certificate"></a> [http\_proxy\_configuration.ssl\_verify\_certificate](#http\_proxy\_configuration.ssl\_verify\_vertificate) | Configures the SSL connection to the HTTP proxy - Enables/disables CA certificate verification                                                                                                                                                      | `string`       | `""`                                                                                        |    no    |
| <a name="input_http_proxy_configuration_ca_certificate"></a> [http\_proxy\_configuration.ca\_certificate](#http\_proxy\_configuration.ca\_certificate)                           | Configures the SSL connection to the HTTP proxy - The path to the Ca certificate to use in the SSL connection to the HTTP proxy                                                                                                                     | `string`       | `""`                                                                                        |    no    |

## Outputs

| Name                                                                                      | Description                                      |
|-------------------------------------------------------------------------------------------|--------------------------------------------------|
| <a name="output_orchestrator_host"></a> [orchestrator\_host](#output\_orchestrator\_host) | The DNS name of the orchestrator's load balancer |
| <a name="output_orchestrator_port"></a> [orchestrator\_port](#output\_orchestrator\_port) | The configured port on the orchestrator          |
<!-- END_TF_DOCS -->
