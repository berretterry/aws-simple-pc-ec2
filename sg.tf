#Security Groups for the Proxy Cluster Bridge and Workers
#------------------------------------------
resource "aws_security_group" "worker" {
  name_prefix = "sdm-proxy-"

  vpc_id = module.vpc.vpc_id

  ingress {
    description     = "Allow TCP:${local.proxy_port} from NLB"
    from_port       = local.proxy_port
    to_port         = local.proxy_port
    security_groups = [aws_security_group.nlb.id]
    protocol        = "tcp"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}
#-----------------------------------------------

#Security Group for the Network Load Balancer
#------------------------------------------------
resource "aws_security_group" "nlb" {
  name_prefix = "sdm-proxy-"

  vpc_id = module.vpc.vpc_id

  ingress {
    description = "Allow TCP:${local.traffic_port} ingress"
    from_port   = local.traffic_port
    to_port     = local.traffic_port
    protocol    = "tcp"
    cidr_blocks = local.ingress_cidr_blocks
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}
#-------------------------------------------------

#Security Group for the EC2 Instance
#------------------------------------------------
resource "aws_security_group" "ec2_ssh" {
  name_prefix = "sdm-proxy-"

  vpc_id = module.vpc.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "ingress_ec2_ssh" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.worker.id
  security_group_id        = aws_security_group.ec2_ssh.id
}
#-------------------------------------------------
