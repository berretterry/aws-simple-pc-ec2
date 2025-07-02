resource "aws_lb" "this" {
  name_prefix = "proxy-" # AWS LBs only support name prefixes <= 6 characters

  internal                         = false
  load_balancer_type               = "network"
  security_groups                  = [aws_security_group.nlb.id]
  subnets                          = module.vpc.public_subnets
  enable_cross_zone_load_balancing = true

}

# https://stackoverflow.com/a/60080801
resource "aws_lb_target_group" "this" {
  name_prefix = "proxy-" # AWS LBs only support name prefixes <= 6 characters
  port        = 8443
  protocol    = "TCP"
  target_type = "ip"
  vpc_id      = module.vpc.vpc_id

  connection_termination = true
  deregistration_delay   = 0

  health_check {
    enabled             = true
    protocol            = "TCP"
    interval            = 5
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  lifecycle {
    create_before_destroy = true
  }

}

resource "aws_lb_listener" "this_sdm" {
  load_balancer_arn = aws_lb.this.arn
  port              = 443
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}