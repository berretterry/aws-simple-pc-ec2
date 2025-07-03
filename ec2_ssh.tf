data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}
resource "aws_instance" "ec2_ssh" {
  ami           = data.aws_ami.al2023.id
  instance_type = "t3.micro"

  subnet_id              = module.vpc.private_subnets[0]
  vpc_security_group_ids = [aws_security_group.ec2_ssh.id]

  # Configures a simple HTTP web page
  user_data = templatefile("${path.module}/ec2_config.tftpl", { SSH_PUB_KEY = data.sdm_ssh_ca_pubkey.this_key.public_key })
  tags      = merge({ Name = "${local.name}-ssh" }, local.tags)
}
