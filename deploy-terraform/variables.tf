variable "aws_region" {
  description = "Region where the Terraform state bucket is created."
  type        = string
  default     = null
}

variable "bucket_name" {
  description = "Name of the Terraform state S3 bucket."
  type        = string
  default     = "deploy-terraform-s3-state"
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
