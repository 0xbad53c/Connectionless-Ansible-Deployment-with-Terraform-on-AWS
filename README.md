# Connectionless Ansible Deployment with Terraform on AWS
Deploying Ansible playbooks &amp; roles to EC2 instances via Terraform from anywhere without interruption and without accessing SSH. Blog post here: https://red.0xbad53c.com/red-team-infrastructure/aws/connectionless-ansible-deployment-with-terraform-via-ssm

# How to use
1. Implement ssm-document/Custom-ApplyAnsiblePlaybooksWithCollections.json as custom SSM document (described in blog)

2. Set variables & update to your liking
```
cp examples/terraform.tfvars.example ./terraform.tfvars
```

3. Execute
```
terraform init
terraform validate
terraform plan
terraform apply
```

# Ansible/test-playbook
This directory contains the main.yml playbook to be executed after dependencies from requirements.yml are installed. The example will download the geerlingguy.apache role from Ansible Galaxy and apply it alongside a basic local test_role (roles subdirectory), which will create /hello-world.txt with contents "hello <testparameter value>". the testparameter can be passed as an ansible extra variable via terraform.tfvars as shown in examples/terraform.tfvars.example.




Enjoy!
