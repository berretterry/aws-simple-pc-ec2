resource "aws_ecs_service" "this" {
  name        = "${local.name}-service"
  launch_type = "FARGATE"

  cluster         = aws_ecs_cluster.this.arn
  task_definition = "${aws_ecs_task_definition.this.id}:${aws_ecs_task_definition.this.revision}"

  desired_count                      = local.worker_count
  force_new_deployment               = true
  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 100

  wait_for_steady_state = true

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  network_configuration {
    subnets          = module.vpc.private_subnets
    security_groups  = [aws_security_group.worker.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.this.arn
    container_name   = "worker"
    container_port   = 8443
  }

  propagate_tags = "SERVICE"

   depends_on = [aws_lb_listener.this_sdm]

  lifecycle {
    postcondition {
      condition     = self.task_definition == "${aws_ecs_task_definition.this.id}:${aws_ecs_task_definition.this.revision}"
      error_message = "The service did not reach the steady state at the requested version"
    }
  }
}