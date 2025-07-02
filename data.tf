# ---------------------------------------------------------------------------- #
# Grab the strongDM CA public key for the authenticated organization
# ---------------------------------------------------------------------------- #
data "sdm_ssh_ca_pubkey" "this_key" {}

data "sdm_account" "existing_users" {
  count = length(local.existing_users)
  type  = "user"
  email = local.existing_users[count.index]
}

data "aws_region" "current" {}

data "aws_availability_zones" "available" {
  state = "available"
}