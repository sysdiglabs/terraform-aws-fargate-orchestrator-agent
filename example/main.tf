module "sysdig_orchestrator_agent" {
  source = "../"

  name = "${var.name}-orchestrator"

  vpc_id = var.vpc_id
  subnets = var.subnets
  collector_host = "collector-staging2.sysdigcloud.com"
  collector_port = "6443"
  access_key = var.sysdig_access_key
  assign_public_ip = true
}

data "sysdig_fargate_workload_agent" "instrumented" {
  container_definitions = jsonencode([
    {
      "image": "quay.io/rehman0288/busyboxplus:latest",
      "name": "busybox",
      "EntryPoint": [
        "watch",
        "-n60",
        "cat",
        "/etc/shadow"
      ],
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": var.name,
          "awslogs-region": "us-east-1",
          "awslogs-stream-prefix": "ecs"
        }
      }
    }
  ])

  sysdig_access_key = var.sysdig_access_key

  workload_agent_image = var.sysdig_workload_agent_image

  orchestrator_host = module.sysdig_orchestrator_agent.orchestrator_host
  orchestrator_port = module.sysdig_orchestrator_agent.orchestrator_port
}
