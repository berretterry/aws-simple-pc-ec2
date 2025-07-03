module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.19.0"

  name = "${local.name}-vpc"
  cidr = "10.0.0.0/16"

  azs = data.aws_availability_zones.available.names

  private_subnets = ["10.0.100.0/24", "10.0.101.0/24"]
  public_subnets  = ["10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway      = true

  tags = merge(
    { Name = "${local.name}-vpc" }, local.tags
  )
}