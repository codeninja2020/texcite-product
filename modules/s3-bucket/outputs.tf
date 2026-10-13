output "bucket_id" {
  description = "Name of the S3 bucket."
  value       = try(aws_s3_bucket.this[0].id, "")
}

output "bucket_arn" {
  description = "ARN of the S3 bucket."
  value       = try(aws_s3_bucket.this[0].arn, "")
}

output "bucket_domain_name" {
  description = "Domain name of the S3 bucket."
  value       = try(aws_s3_bucket.this[0].bucket_domain_name, "")
}

output "bucket_regional_domain_name" {
  description = "Region-specific domain name of the S3 bucket."
  value       = try(aws_s3_bucket.this[0].bucket_regional_domain_name, "")
}

output "bucket_hosted_zone_id" {
  description = "Route 53 hosted zone ID for the S3 bucket region."
  value       = try(aws_s3_bucket.this[0].hosted_zone_id, "")
}

output "bucket_region" {
  description = "AWS region where the bucket resides."
  value       = ""
}

output "bucket_policy" {
  description = "Bucket policy JSON if one is attached."
  value       = try(aws_s3_bucket_policy.this[0].policy, "")
}

output "bucket_versioning_status" {
  description = "Bucket versioning status."
  value       = try(aws_s3_bucket_versioning.this[0].versioning_configuration[0].status, null)
}

output "bucket_website_endpoint" {
  description = "Website endpoint if website hosting is configured."
  value       = try(aws_s3_bucket_website_configuration.this[0].website_endpoint, "")
}

output "bucket_website_domain" {
  description = "Website domain if website hosting is configured."
  value       = try(aws_s3_bucket_website_configuration.this[0].website_domain, "")
}

output "bucket_tags" {
  description = "Tags applied to the bucket."
  value       = try(aws_s3_bucket.this[0].tags, {})
}

output "s3_bucket_id" {
  description = "terraform-aws-s3-bucket compatible bucket ID output."
  value       = try(aws_s3_bucket.this[0].id, "")
}

output "s3_bucket_arn" {
  description = "terraform-aws-s3-bucket compatible bucket ARN output."
  value       = try(aws_s3_bucket.this[0].arn, "")
}

output "s3_bucket_bucket_domain_name" {
  description = "terraform-aws-s3-bucket compatible bucket domain name output."
  value       = try(aws_s3_bucket.this[0].bucket_domain_name, "")
}

output "s3_bucket_bucket_regional_domain_name" {
  description = "terraform-aws-s3-bucket compatible bucket regional domain name output."
  value       = try(aws_s3_bucket.this[0].bucket_regional_domain_name, "")
}

output "aws_s3_bucket_versioning_status" {
  description = "terraform-aws-s3-bucket compatible versioning status output."
  value       = try(aws_s3_bucket_versioning.this[0].versioning_configuration[0].status, null)
}
