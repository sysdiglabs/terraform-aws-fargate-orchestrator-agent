# Example

This example uses the Sysdig Fargate Orchestrator module along with the Sysdig Terraform provider to deploy an instrumented ECS Task that is performing a suspicious activity.

## Usage

Initialize the state using `terraform init`

Run `terraform apply`. Enter your values for the required variables.

```
terraform apply \
        -var='name=<name>' \
        -var='sysdig_access_key=<sysdig_access_key>' \
        -var='vpc_id=<vpc_id>' \
        -var='subnets=["<subnet_a>", "<subnet_b>", ...]
```

After a few minutes, the orchestrator and workload should be up. You can see the workload logs with `aws logs tail <name> --follow` and the orchestrator logs using `aws logs tail <name>-orchestrator-logs --follow`, using the value you gave Terraform for `name`.

Clean up by running `terraform destroy`.
