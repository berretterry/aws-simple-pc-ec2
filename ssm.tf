resource "aws_ssm_parameter" "secret_key" {
  name = "/strongdm/proxy-cluster/${local.name}-proxy/secret-key"
  type = "SecureString"

  value = sdm_proxy_cluster_key.this.secret_key

}