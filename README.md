# aws-simple-pc-ec2

Terraform module to quickly spin up an EC2 instance with a proxy cluster for testing.

## Infrastructure

### AWS

An EC2 instance is created in a private subnet with outbound access the internet. The instance also gets Docker and Git installed during instantiation.

### SDM

In StrongDM a Proxy Cluster is created alongside the SSH server.

An auto approval workflow is created and the EC2 instance is added. Any user email provided in the `existing users` section of the config.tf file will be able to request access to the resource.

## Customize the Deployment

Please open the `config.tf` file and fill out the following items:

- [ ] **name**: This is the project name and will be a prefix for most resources deployed in AWS and SDM.
- [ ] **tags**: These are the tags you want put on all of your resources in AWS and especially SDM
- [ ] **aws_region**: This is required for deployment and will be the region that everything is deployed in.
- [ ] **existing_users**: This is a list of existing user emails that you would like to have workflow access to these resources.

> [!NOTE]
> The email addresses MUST already exist in the StrongDM tenant you are deploying these resources to; otherwise, the plan/apply will fail.

---

## To Run the Module

> [!WARNING]
> These scripts create infrastructure resources in your AWS account, incurring AWS costs. Once you are done testing, remove these resources to prevent unnecessary AWS costs. You can remove resources manually or with `terraform destroy`. StrongDM provides these scripts as is, and does not accept liability for any alterations to AWS assets or any AWS costs incurred.

1. Clone the repository:

   ```shell
   git clone https://github.com/strongdm/terraform-sdm-onboarding.git
   ```

2. Switch to the directory containing the cloned project:

   ```shell
   cd cs-pc-aws-demo
   ```

3. Set environment variables for the API key

   ```shell
   # strongdm access and secret keys
   export SDM_API_ACCESS_KEY=auth-xxxxxxxxxxxx
   export SDM_API_SECRET_KEY=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

   # For the AWS creds, ideally set your profile.
   export AWS_PROFILE=<profile-name>

   # Otherwise, set your keys
   # export AWS_ACCESS_KEY_ID=xxxxxxxxx
   # export AWS_SECRET_ACCESS_KEY=xxxxxxxxx
   ```

4. Initialize the working directory containing the Terraform configuration files:

   ```shell
   terraform init
   ```

5. Execute the actions proposed in the Terraform plan:

   ```shell
   terraform apply
   ```

> [!NOTE]
> The script runs until it is complete. Note any errors. If there are no errors, you should see new resources, such as databases, clusters, or servers, in the StrongDM Admin UI. Additionally, your AWS Management Console displays any new resources added when you ran the module.

6. Remove the resources created with Terraform Destroy:

   ```shell
   terraform destroy
   ```
