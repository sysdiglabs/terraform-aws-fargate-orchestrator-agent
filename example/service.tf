resource "aws_ecs_cluster" "example_cluster" {
  name = var.name
}

resource "aws_cloudwatch_log_group" "example_logs" {
  name = var.name
}

resource "aws_iam_role" "example_execution_role" {
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json

  managed_policy_arns = ["arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"]
}

resource "aws_iam_role" "example_task_role" {
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json

  inline_policy {
    name = "root"
    policy = data.aws_iam_policy_document.task_policy.json
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
    subnets = var.subnets
    security_groups = [ aws_security_group.example_security_group.id ]
    assign_public_ip = true
  }
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "task_policy" {
  statement {
    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = ["*"]
  }
}
