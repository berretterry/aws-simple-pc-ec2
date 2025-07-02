#Create SDM Proxy Cluster
resource "sdm_node" "proxy-cluster" {
  proxy_cluster {
    name    = "${local.name}-proxy-cluster"
    address = "${aws_lb.this.dns_name}:443"
    tags = local.tags

  }
}

#Create EC2 SSH instance
resource "sdm_resource" "ssh_ec2" {
  ssh_cert {
    name     = "${local.name}-ssh"
    username = "ec2-user"
    hostname = aws_instance.ec2_ssh.private_ip
    port     = 22
    tags     = merge(
      { Name = "${local.name}-ssh" },
      {"workflow" : "${local.name}-workflow"},
      local.tags)

    proxy_cluster_id = sdm_node.proxy-cluster.id
  }
}

resource "sdm_proxy_cluster_key" "this" {
  proxy_cluster_id = sdm_node.proxy-cluster.id
}

#Create a role to attach to users to use the workflow
resource "sdm_role" "workflow" {
  name         = "${local.name}-workflow-role"
  # access_rules = jsonencode([
  #   { tags = { CreatedBy = "strongDM-Onboarding" } }
  # ])
}

#Attach existing users to the role provided
resource "sdm_account_attachment" "existing_users" {
  count      = length(local.existing_users)
  account_id = element(data.sdm_account.existing_users[count.index].ids, 0)
  role_id    = sdm_role.workflow.id
}

#create the approval workflow and determine if it is manual or automatic. This example is automatic manual example can be found in our terraform provider: https://registry.terraform.io/providers/strongdm/sdm/latest/docs/resources/approval_workflow
resource "sdm_approval_workflow" "this" {
    name = "${local.name} approval workflow"
    approval_mode = "automatic"
}

#create the actual workflow
resource "sdm_workflow" "this" {
    name         = "${local.name} automatic workflow"
    auto_grant   = true
    enabled      = true
    approval_flow_id = sdm_approval_workflow.this.id
    description  = "${local.name} automatic workflow"
    access_rules = jsonencode([
    {
      "tags" : {
        "workflow" : "${local.name}-workflow"
      }
    }
  ])
}

#WorkflowRole links a role to a workflow. The linked roles indicate which roles a user must be a part of to request access to a resource via the workflow.
resource "sdm_workflow_role" "this" {
    workflow_id = sdm_workflow.this.id
    role_id     = sdm_role.workflow.id
}
