locals {
  environment_config = yamldecode(file("${path.module}/${var.environment_config_file}"))
  environment        = try(local.environment_config.environment, null)
  aws_region         = coalesce(var.aws_region, try(local.environment_config.aws_region, null), "us-east-1")
  s3_bucket_name     = coalesce(var.bucket_name, try(local.environment_config.bucket_name, null), "deploy-terraform-s3-state")
  tags               = merge(try(local.environment_config.tags, {}), local.environment == null ? {} : { Environment = local.environment }, var.tags)
}
