module "sysdig_orchestrator_agent" {
  source = "../"

  name = "${var.name}-orchestrator"

  vpc_id = var.vpc_id
  subnet_a = var.subnet_a
  subnet_b = var.subnet_b
  collector_host = "collector-staging2.sysdigcloud.com"
  collector_port = "6443"
  access_key = var.sysdig_access_key
  assign_public_ip = true
}

resource "aws_ecs_cluster" "example_cluster" {
  name = var.name
}

resource "aws_cloudwatch_log_group" "example_logs" {
  name = var.name
}

resource "aws_iam_role" "example_execution_role" {
  assume_role_policy = jsonencode({
    Version: "2012-10-17",
    Statement: [
      {
        Action: "sts:AssumeRole",
        Principal: {
          Service: "ecs-tasks.amazonaws.com"
        },
        Effect: "Allow"
      }
    ]
  })

  managed_policy_arns = ["arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"]
}

resource "aws_iam_role" "example_task_role" {
  assume_role_policy = jsonencode({
    Version: "2012-10-17",
    Statement: [
      {
        Action: "sts:AssumeRole",
        Principal: {
          Service: "ecs-tasks.amazonaws.com"
        },
        Effect: "Allow"
      }
    ]
  })

  inline_policy {
    name = "root"

    policy = jsonencode({
      Version: "2012-10-17",
      Statement: [
        {
          Action: [
            "ecr:GetAuthorizationToken",
            "ecr:BatchCheckLayerAvailability",
            "ecr:GetDownloadUrlForLayer",
            "ecr:BatchGetImage",
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents",
          ],
          Effect: "Allow"
          Resource: "*"
        }
      ]
    })
  }
}

resource "aws_security_group" "example_security_group" {
  description = "Allow workload to reach internet"
  vpc_id = var.vpc_id
}

resource "aws_security_group_rule" "example_egress_rule" {
  type = "egress"
  protocol = "all"
  from_port = 0
  to_port = 0
  cidr_blocks = [ "0.0.0.0/0" ]
  security_group_id = aws_security_group.example_security_group.id
}

resource "aws_ecs_task_definition" "example_task_definition" {
  family = var.name
  task_role_arn = aws_iam_role.example_task_role.arn
  execution_role_arn = aws_iam_role.example_execution_role.arn

  cpu = "256"
  memory = "1GB"
  network_mode = "awsvpc"
  requires_compatibilities = ["FARGATE"]

  container_definitions = data.sysdig_fargate_workload_agent.instrumented.output_container_definitions
}

resource "aws_ecs_service" "example_service" {
  name = var.name

  cluster = aws_ecs_cluster.example_cluster.id
  task_definition = aws_ecs_task_definition.example_task_definition.arn
  desired_count = 1
  launch_type = "FARGATE"
  platform_version = "1.4.0"

  network_configuration {
    subnets = [
      var.subnet_a,
      var.subnet_b
    ]
    security_groups = [ aws_security_group.example_security_group.id ]
    assign_public_ip = true
  }
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
