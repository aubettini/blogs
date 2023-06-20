provider "aws" {
  region  = "eu-west-1" // replace with your region
  version = "4.67.0"
}

resource "aws_ecr_repository" "my_repository" {
  name                 = "express-api" // replace with your repository name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }
}

output "repository_url" {
  description = "URL of the ECR repository"
  value       = aws_ecr_repository.my_repository.repository_url
}

data "aws_ecs_task_definition" "express_api" {
  task_definition = aws_ecs_task_definition.express_api.family
}

resource "aws_ecs_cluster" "express_api_cluster" {
  name = "express-api-cluster"
}

resource "aws_ecs_task_definition" "express_api" {
  family                   = "express-api-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.express-api-execution.arn
  task_role_arn            = aws_iam_role.express-api-task.arn

  container_definitions = <<DEFINITION
  [
    {
      "name": "express-api",
      "image": "${aws_ecr_repository.my_repository.repository_url}:latest",
      "essential": true,
      "portMappings": [
        {
          "containerPort": 8080,
          "hostPort": 8080
        }
      ],
      "memory": 512,
      "cpu": 256,
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "express-api",
          "awslogs-region": "eu-west-1",
          "awslogs-stream-prefix": "express-api"
        }
      }
    }
  ]
  DEFINITION
}

# log group
resource "aws_cloudwatch_log_group" "express_api" {
  name              = "express-api"
  retention_in_days = 7
}

resource "aws_ecs_service" "express_api_service" {
  name            = "express-api-service"
  cluster         = aws_ecs_cluster.express_api_cluster.id
  task_definition = aws_ecs_task_definition.express_api.arn
  desired_count   = 3

  capacity_provider_strategy {
    capacity_provider = "FARGATE_SPOT"
    weight            = "1"
  }

  network_configuration {
    subnets          = module.vpc.public_subnets
    security_groups  = [aws_security_group.express_api.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.express_api_tg.arn
    container_name   = "express-api"
    container_port   = 8080
  }
}

resource "aws_lb_target_group" "express_api_tg" {
  name        = "express-api-tg"
  port        = 8080
  protocol    = "TCP"
  vpc_id      = module.vpc.vpc_id
  target_type = "ip"

  health_check {
    path = "/"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb" "express_api" {
  name               = "express-api"
  internal           = false
  load_balancer_type = "network" # use "network" instead of "application" for NLB
  subnets            = module.vpc.public_subnets

  enable_deletion_protection = false
}

resource "aws_lb_listener" "express_api" {
  load_balancer_arn = aws_lb.express_api.arn
  port              = "80"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.express_api_tg.arn
  }
}

resource "aws_iam_role" "express-api-execution" {
  name               = "express-api-execution"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role" "express-api-task" {
  name               = "express-api-task"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

# Dynamodb access
resource "aws_iam_role_policy_attachment" "express-api-task-dynamodb" {
  role       = aws_iam_role.express-api-task.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
}

resource "aws_iam_role_policy_attachment" "express-api-task" {
  role       = aws_iam_role.express-api-task.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "express-api-task-ecr" {
  role       = aws_iam_role.express-api-task.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
}

resource "aws_iam_role_policy_attachment" "express-api-task-logs" {
  role       = aws_iam_role.express-api-task.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}

resource "aws_iam_role_policy_attachment" "express-api-task-ssm" {
  role       = aws_iam_role.express-api-task.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMFullAccess"
}

resource "aws_iam_role_policy_attachment" "express-api-task-ec2" {
  role       = aws_iam_role.express-api-task.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

resource "aws_iam_role_policy_attachment" "express-api-task-ecs" {
  role       = aws_iam_role.express-api-task.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonECS_FullAccess"
}

resource "aws_iam_policy" "ecr_permissions" {
  name   = "ecr-permissions"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ecr:BatchCheckLayerAvailability",
        "ecr:BatchGetImage",
        "ecr:GetDownloadUrlForLayer",
        "ecr:GetAuthorizationToken"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "dynamodb:BatchGetItem",
        "dynamodb:BatchWriteItem",
        "dynamodb:PutItem",
        "dynamodb:DeleteItem",
        "dynamodb:GetItem",
        "dynamodb:Scan",
        "dynamodb:Query",
        "dynamodb:UpdateItem"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "express-api-execution-ecr" {
  role       = aws_iam_role.express-api-execution.name
  policy_arn = aws_iam_policy.ecr_permissions.arn
}

# give CW permission to express-api-execution
resource "aws_iam_role_policy_attachment" "express-api-execution-cw" {
  role       = aws_iam_role.express-api-execution.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchFullAccess"
}

# This is for testing purposes only
resource "aws_security_group" "express_api" {
  name        = "express_api"
  description = "Allow inbound traffic on port 8080"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = module.vpc.vpc_id
}
