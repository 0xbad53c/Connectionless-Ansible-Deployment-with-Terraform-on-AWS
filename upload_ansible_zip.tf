// archive ansible directory
locals {
  // calculate ansible_folder_checksum to track changes
  ansible_folder_checksum = sha1(join("", [for f in fileset(var.path_to_ansible_folder, "**") : filesha1("${var.path_to_ansible_folder}/${f}")]))
}

// Every time a file changes in the ansible directory, the zip will be recreated
// because of local.ansible_folder_checksum
data "archive_file" "ansible_dir_zip" {
  type        = "zip"
  source_dir  = var.path_to_ansible_folder
  output_path = "${path.module}/${local.bucket_name}.zip" // avoid collisions with same module running for different instances
}

// upload ansible directory as zip
resource "aws_s3_object" "ansible_dir_zip" {
  bucket = aws_s3_bucket.ansible.id
  key    = var.s3_zip_object_key
  source = data.archive_file.ansible_dir_zip.output_path

  etag = filemd5(data.archive_file.ansible_dir_zip.output_path)
}
