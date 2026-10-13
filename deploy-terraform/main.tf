module "terraform_state_bucket" {
  source = "../modules/s3-bucket"

  bucket_name        = local.s3_bucket_name
  tags               = local.tags
  versioning_enabled = false
}
