#ECS Cluster
resource "aws_ecs_cluster" "this" {
  name = "${local.name}-ecs"
}

