locals {
  # Name will be added to resource names
  name                    = "pc-ec2"

  # Tags will be added to strongDM and AWS resources.
  tags                    = {
    project = "${local.name}"
    }

  # List of email addresses of existing StrongDM users who will receive access to all resources
  # !!!Must be a valid email address IN the tenant you are trying to add resources to!!!
  existing_users          = ["berret.terry+cssandbox@strongdm.com"]

  #AWS Region you want resources deployed in
  aws_region              = "us-west-2"

#A list of CIDR blocks from which to allow ingress traffic"
  ingress_cidr_blocks     = ["0.0.0.0/0"]

#Number of workers to run in the proxy cluster
  worker_count            = 1

#Amount of vCPU each worker should have.
  worker_cpu              = 2048

#Amount of memory each worker should have.
  worker_memory           = 4096

#proxy port from nlb to proxy cluster worker
  proxy_port              = 8443

#Proxy Cluster default traffic port
  traffic_port            = 443
}