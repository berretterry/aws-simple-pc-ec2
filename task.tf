resource "aws_ecs_task_definition" "this" {
  family                   = "${local.name}-worker"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = local.worker_cpu
  memory                   = local.worker_memory
  execution_role_arn       = aws_iam_role.this_task_execution.arn
  task_role_arn            = aws_iam_role.this_task.arn

  container_definitions    = jsonencode([
      {
        name                          = "worker"
        image                         = "public.ecr.aws/strongdm/relay:latest"
        essential                     = true
        networkMode                   = "awsvpc"

        logConfiguration = {
          logDriver = "awslogs"
          options = {
            mode                  = "non-blocking"
            awslogs-group         = aws_cloudwatch_log_group.this.name
            awslogs-stream-prefix = "${local.name}-"
            awslogs-region        = data.aws_region.current.name
         }
       }

        environment = [
        {
          name  = "SDM_DOCKERIZED"
          value = "true"
        },
        {
          name  = "SDM_BIND_ADDRESS"
          value = ":${local.proxy_port}"
        },
        {
          name  = "SDM_PROXY_CLUSTER_ACCESS_KEY"
          value = sdm_proxy_cluster_key.this.id
        },
        ]

      secrets = [
        {
          name      = "SDM_PROXY_CLUSTER_SECRET_KEY"
          valueFrom = aws_ssm_parameter.secret_key.arn
        },
      ]

        portMappings = [{
          protocol      = "tcp"
          containerPort = local.proxy_port
        }]
      }
    ]
  )
}

