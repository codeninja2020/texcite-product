variable "aws_region" {
  description = "AWS region where resources are created."
  type        = string
  default     = null
}

variable "bucket_name" {
  description = "Name of the S3 bucket to create."
  type        = string
  default     = "deploy-aws-s3bucket"
}

variable "tags" {
  description = "Tags applied to all supported resources."
  type        = map(string)
  default     = {}
}

variable "environment_config_file" {
  description = "Environment YAML file to load for this Terraform stack."
  type        = string
  default     = ".component_config.yml"
}
