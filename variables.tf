// s3 bucket with Ansible playbook
variable "path_to_ansible_folder" {
  description = "Path to the ansible from which to apply the main.yml playbook."
  type        = string
  default     = "ansible/test-playbook"
}

variable "s3_data_expiration_days" {
  description = "Amount of days to keep the uploaded data in s3. Should be 1 unless used for logging afterwards."
  type        = number
  default     = 1
}

variable "s3_zip_object_key" {
  description = "Name of the s3 bucket object key of the zip file. Normally, this should be ansible.zip."
  type        = string
  default     = "ansible.zip"
}

// EC2 instance
variable "vpc_name" {
  description = "Name of the VPC."
  type        = string
}

variable "server_name" {
  description = "Name of the server."
  type        = string
}

variable "instance_type" {
  description = "Aws EC2 instance type to use."
  default     = "t3a.nano"
  type        = string
}

variable "subnet_name" {
  description = "Name of the subnet to deploy the machine in. Leave default in most situations."
  type        = string
}

variable "ebs_volume_size" {
  description = "EBS size in GB."
  type        = number
  default     = 8
}

variable "delete_ebs_on_termination" {
  description = "Whether to delete the volume on termination. True avoids costs and destroys data after tearing down the environment."
  type        = bool
  default     = true
}

variable "source_dest_check" {
  description = "Whether to set the source_dest_check to enable IP forwarding in AWS. Set to false for VPN server."
  type        = bool
  default     = true
}
variable "private_ip" {
  description = "Private IP address to set. Leave blank to let AWS decide."
  type        = string
  default     = ""
}

variable "ssh_key_local_directory" {
  description = "Directory to store the SSH key."
  type        = string
  default     = "./ssh_keys"
}

// use AMI with Amazon SSM Agent preinstalled
// e.g. Ubuntu server 22.04
variable "ami" {
  description = "AWS AMI to deploy"
  type        = string
  default     = "ami-0932dacac40965a65" // Do not update build on actively used instances or machine will be destroyed
}

// push additional extra_vars
variable "ansible_extra_vars" {
  description = "List of key-value pairs of variables to pass to ansible"
  type        = map(string)
}
