output "terraform_state_bucket_id" {
  description = "Name of the Terraform state S3 bucket."
  value       = module.terraform_state_bucket.bucket_id
}

output "terraform_state_bucket_arn" {
  description = "ARN of the Terraform state S3 bucket."
  value       = module.terraform_state_bucket.bucket_arn
}

output "terraform_state_bucket_versioning_status" {
  description = "Versioning status for the Terraform state S3 bucket."
  value       = module.terraform_state_bucket.bucket_versioning_status
}
