resource "aws_iam_role" "orchestrator_agent_execution_role" {
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

  tags = merge(var.tags, var.default_tags)
}

resource "aws_iam_role" "orchestrator_agent_task_role" {
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

  tags = merge(var.tags, var.default_tags)
}
