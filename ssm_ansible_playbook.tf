locals {
  ansible_extra_vars_string = join(" ", [for k, v in var.ansible_extra_vars : "${k}=${v}"])
}

// Associate the document with the instance
// Uses a custom version of AWS-ApplyAnsiblePlaybooks (ApplyAnsiblePlaybooksWithCollections) to also install dependencies with ansible-galaxy
resource "aws_ssm_association" "ansible_playbook_association" {
  name             = "Custom-ApplyAnsiblePlaybooksWithCollections" //based on AWS-ApplyAnsiblePlaybooks
  association_name = "${var.server_name}_playbook_association"

  // targets to run the document on
  targets {
    key    = "InstanceIds"
    values = [aws_instance.ec2_instance.id]

  }

  parameters = {
    SourceType = "S3"
    SourceInfo = jsonencode({
      path = "https://s3.amazonaws.com/${aws_s3_bucket.ansible.id}/ansible.zip"
    })

    // We can use ExtraVariables to pass parameters to the playbook 
    // always include etag to retrigger playbook apply on change of playbook
    // always include s3bucket if you would like to upload custom data
    ExtraVariables      = "SSM=True ${local.ansible_extra_vars_string} s3bucket=${aws_s3_bucket.ansible.id} s3_object_etag=${aws_s3_object.ansible_dir_zip.etag}"
    InstallDependencies = "True"             // if Ansible must still be installed, should be True in most cases unles using own image with Ansible preinstalled
    InstallCollections  = "True"            // can toggle to install ansible-galaxy dependencies
    RequirementsFile    = "requirements.yml" // where to install dependencies from. Should be in the root on ansible.zip
    PlaybookFile        = "main.yml"         // should be in the root on ansible.zip
  }

  // output logs to bucket
  // This means putObject is needed
  output_location {
    s3_bucket_name = aws_s3_bucket.ansible.id
  }

  automation_target_parameter_name = "InstanceId"
  max_concurrency                  = "1"
  max_errors                       = "0"
}
