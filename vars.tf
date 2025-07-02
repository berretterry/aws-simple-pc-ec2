# variable "aws_region" {
#   type = string
# }

# variable "name" {
#   description = "This name is applied to resources where applicable, e.g. titles and tags."
#   type        = string
# }

# variable "tags" {
#   description = "Tags to be applied to reasources created by this module"
#   type        = map(string)
#   default     = {}
# }

# variable "vpc_id" {
#   description = "VPC ID is used to assign security groups in the correct network"
#   type        = string
# }

# variable "private_subnet_ids" {
#   description = "strongDM proxy workers will be deployed into the subnets provided"
#   type        = list(string)
#   default     = module.vpc.private_subnet_ids
# }

# variable "public_subnet_ids" {
#   description = "The NLB will be deployed into the subnets provided"
#   type        = list(string)
#   default     = module.vpc.public_subnet_ids
# }

# variable "ingress_cidr_blocks" {
#   description = "A list of CIDR blocks from which to allow ingress traffic"
#   type        = list(string)
#   default     = ["0.0.0.0/0"]
# }

# variable "worker_count" {
#   description = "Number of workers to run in the proxy cluster"
#   type        = number
#   default     = 1
# }

# variable "worker_cpu" {
#   type        = number
#   default     = 2048
#   description = "Amount of vCPU each worker should have."
# }

# variable "worker_memory" {
#   type        = number
#   default     = 4096
#   description = "Amount of memory each worker should have."
# }

# variable "sdm_proxy_cluster_secret_key" {
#   description = "This is the key from StrongDM for the Proxy Cluster install."
#   type        = string
# }

# variable "sdm_proxy_cluster_access_key" {
#   description = "This is the key from StrongDM for the Proxy Cluster install."
#   type        = string
# }

# variable "eks_role_arn" {
#   description = "The ARN of the EKS IAM role that needs to assume the correct role for sdm access"
#   type        = string
# }
