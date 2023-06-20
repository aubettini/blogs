## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 4.67.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.67.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | 3.2.0 |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.express_api](https://registry.terraform.io/providers/hashicorp/aws/4.67.0/docs/resources/cloudwatch_log_group) | resource |
| [aws_ecr_repository.my_repository](https://registry.terraform.io/providers/hashicorp/aws/4.67.0/docs/resources/ecr_repository) | resource |
| [aws_ecs_cluster.express_api_cluster](https://registry.terraform.io/providers/hashicorp/aws/4.67.0/docs/resources/ecs_cluster) | resource |
| [aws_ecs_service.express_api_service](https://registry.terraform.io/providers/hashicorp/aws/4.67.0/docs/resources/ecs_service) | resource |
| [aws_ecs_task_definition.express_api](https://registry.terraform.io/providers/hashicorp/aws/4.67.0/docs/resources/ecs_task_definition) | resource |
| [aws_iam_policy.ecr_permissions](https://registry.terraform.io/providers/hashicorp/aws/4.67.0/docs/resources/iam_policy) | resource |
| [aws_iam_role.express-api-execution](https://registry.terraform.io/providers/hashicorp/aws/4.67.0/docs/resources/iam_role) | resource |
| [aws_iam_role.express-api-task](https://registry.terraform.io/providers/hashicorp/aws/4.67.0/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.express-api-execution-cw](https://registry.terraform.io/providers/hashicorp/aws/4.67.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.express-api-execution-ecr](https://registry.terraform.io/providers/hashicorp/aws/4.67.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.express-api-task](https://registry.terraform.io/providers/hashicorp/aws/4.67.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.express-api-task-dynamodb](https://registry.terraform.io/providers/hashicorp/aws/4.67.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.express-api-task-ec2](https://registry.terraform.io/providers/hashicorp/aws/4.67.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.express-api-task-ecr](https://registry.terraform.io/providers/hashicorp/aws/4.67.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.express-api-task-ecs](https://registry.terraform.io/providers/hashicorp/aws/4.67.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.express-api-task-logs](https://registry.terraform.io/providers/hashicorp/aws/4.67.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.express-api-task-ssm](https://registry.terraform.io/providers/hashicorp/aws/4.67.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_lb.express_api](https://registry.terraform.io/providers/hashicorp/aws/4.67.0/docs/resources/lb) | resource |
| [aws_lb_listener.express_api](https://registry.terraform.io/providers/hashicorp/aws/4.67.0/docs/resources/lb_listener) | resource |
| [aws_lb_target_group.express_api_tg](https://registry.terraform.io/providers/hashicorp/aws/4.67.0/docs/resources/lb_target_group) | resource |
| [aws_security_group.express_api](https://registry.terraform.io/providers/hashicorp/aws/4.67.0/docs/resources/security_group) | resource |
| [aws_ecs_task_definition.express_api](https://registry.terraform.io/providers/hashicorp/aws/4.67.0/docs/data-sources/ecs_task_definition) | data source |

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_repository_url"></a> [repository\_url](#output\_repository\_url) | URL of the ECR repository |

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 4.67.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.67.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | 3.2.0 |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.express_api](https://registry.terraform.io/providers/hashicorp/aws/4.67.0/docs/resources/cloudwatch_log_group) | resource |
| [aws_ecr_repository.my_repository](https://registry.terraform.io/providers/hashicorp/aws/4.67.0/docs/resources/ecr_repository) | resource |
| [aws_ecs_cluster.express_api_cluster](https://registry.terraform.io/providers/hashicorp/aws/4.67.0/docs/resources/ecs_cluster) | resource |
| [aws_ecs_service.express_api_service](https://registry.terraform.io/providers/hashicorp/aws/4.67.0/docs/resources/ecs_service) | resource |
| [aws_ecs_task_definition.express_api](https://registry.terraform.io/providers/hashicorp/aws/4.67.0/docs/resources/ecs_task_definition) | resource |
| [aws_iam_policy.ecr_permissions](https://registry.terraform.io/providers/hashicorp/aws/4.67.0/docs/resources/iam_policy) | resource |
| [aws_iam_role.express-api-execution](https://registry.terraform.io/providers/hashicorp/aws/4.67.0/docs/resources/iam_role) | resource |
| [aws_iam_role.express-api-task](https://registry.terraform.io/providers/hashicorp/aws/4.67.0/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.express-api-execution-cw](https://registry.terraform.io/providers/hashicorp/aws/4.67.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.express-api-execution-ecr](https://registry.terraform.io/providers/hashicorp/aws/4.67.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.express-api-task](https://registry.terraform.io/providers/hashicorp/aws/4.67.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.express-api-task-dynamodb](https://registry.terraform.io/providers/hashicorp/aws/4.67.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.express-api-task-ec2](https://registry.terraform.io/providers/hashicorp/aws/4.67.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.express-api-task-ecr](https://registry.terraform.io/providers/hashicorp/aws/4.67.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.express-api-task-ecs](https://registry.terraform.io/providers/hashicorp/aws/4.67.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.express-api-task-logs](https://registry.terraform.io/providers/hashicorp/aws/4.67.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.express-api-task-ssm](https://registry.terraform.io/providers/hashicorp/aws/4.67.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_lb.express_api](https://registry.terraform.io/providers/hashicorp/aws/4.67.0/docs/resources/lb) | resource |
| [aws_lb_listener.express_api](https://registry.terraform.io/providers/hashicorp/aws/4.67.0/docs/resources/lb_listener) | resource |
| [aws_lb_target_group.express_api_tg](https://registry.terraform.io/providers/hashicorp/aws/4.67.0/docs/resources/lb_target_group) | resource |
| [aws_security_group.express_api](https://registry.terraform.io/providers/hashicorp/aws/4.67.0/docs/resources/security_group) | resource |
| [aws_ecs_task_definition.express_api](https://registry.terraform.io/providers/hashicorp/aws/4.67.0/docs/data-sources/ecs_task_definition) | data source |

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_repository_url"></a> [repository\_url](#output\_repository\_url) | URL of the ECR repository |
<!-- END_TF_DOCS -->