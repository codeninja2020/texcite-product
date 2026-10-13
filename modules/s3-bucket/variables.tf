variable "create_bucket" {
  description = "Controls whether the S3 bucket and related resources are created."
  type        = bool
  default     = true
}

variable "bucket_name" {
  description = "Name of the S3 bucket. Kept for compatibility with this repository's stack."
  type        = string
  default     = null
}

variable "bucket" {
  description = "Name of the S3 bucket. Mirrors the terraform-aws-s3-bucket module interface."
  type        = string
  default     = null
}

variable "bucket_prefix" {
  description = "Creates a unique bucket name beginning with the specified prefix. Conflicts with bucket and bucket_name."
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags applied to the S3 bucket."
  type        = map(string)
  default     = {}
}

variable "force_destroy" {
  description = "Whether all objects should be deleted from the bucket when destroying the bucket."
  type        = bool
  default     = false
}

variable "object_lock_enabled" {
  description = "Whether S3 object lock is enabled on the bucket."
  type        = bool
  default     = false
}

variable "expected_bucket_owner" {
  description = "Account ID of the expected bucket owner."
  type        = string
  default     = null
}

variable "create_public_access_block" {
  description = "Whether to create an S3 public access block for the bucket."
  type        = bool
  default     = true
}

variable "block_public_acls" {
  description = "Whether Amazon S3 should block public ACLs for this bucket."
  type        = bool
  default     = true
}

variable "block_public_policy" {
  description = "Whether Amazon S3 should block public bucket policies for this bucket."
  type        = bool
  default     = true
}

variable "ignore_public_acls" {
  description = "Whether Amazon S3 should ignore public ACLs for this bucket."
  type        = bool
  default     = true
}

variable "restrict_public_buckets" {
  description = "Whether Amazon S3 should restrict public bucket policies for this bucket."
  type        = bool
  default     = true
}

variable "object_ownership" {
  description = "Object ownership setting for the bucket. Use null to skip ownership controls."
  type        = string
  default     = "BucketOwnerEnforced"

  validation {
    condition     = var.object_ownership == null || contains(["BucketOwnerEnforced", "BucketOwnerPreferred", "ObjectWriter"], var.object_ownership)
    error_message = "object_ownership must be one of BucketOwnerEnforced, BucketOwnerPreferred, ObjectWriter, or null."
  }
}

variable "acl" {
  description = "Canned ACL to apply. Skipped when object_ownership is BucketOwnerEnforced because ACLs are disabled."
  type        = string
  default     = null
}

variable "attach_policy" {
  description = "Whether to attach the JSON bucket policy in policy."
  type        = bool
  default     = false
}

variable "policy" {
  description = "Valid bucket policy JSON document."
  type        = string
  default     = null
}

variable "encryption_enabled" {
  description = "Whether to create bucket server-side encryption configuration."
  type        = bool
  default     = true
}

variable "sse_algorithm" {
  description = "Server-side encryption algorithm. Valid values include AES256 and aws:kms."
  type        = string
  default     = "AES256"

  validation {
    condition     = contains(["AES256", "aws:kms", "aws:kms:dsse"], var.sse_algorithm)
    error_message = "sse_algorithm must be AES256, aws:kms, or aws:kms:dsse."
  }
}

variable "kms_master_key_id" {
  description = "KMS key ID or ARN used when sse_algorithm is aws:kms or aws:kms:dsse."
  type        = string
  default     = null
}

variable "bucket_key_enabled" {
  description = "Whether S3 bucket keys are enabled for KMS encryption."
  type        = bool
  default     = null
}

variable "versioning_enabled" {
  description = "Whether bucket versioning is enabled. Set null to skip versioning configuration."
  type        = bool
  default     = true
}

variable "versioning" {
  description = "Versioning configuration matching the terraform-aws-s3-bucket module interface."
  type = object({
    enabled = optional(bool)
  })
  default = null
}

variable "versioning_mfa_delete" {
  description = "MFA delete status for bucket versioning. Valid values are Enabled or Disabled."
  type        = string
  default     = null

  validation {
    condition     = var.versioning_mfa_delete == null || contains(["Enabled", "Disabled"], var.versioning_mfa_delete)
    error_message = "versioning_mfa_delete must be Enabled, Disabled, or null."
  }
}

variable "versioning_mfa" {
  description = "MFA token used for versioning changes when MFA delete is configured."
  type        = string
  default     = null
}

variable "website" {
  description = "Map containing static website hosting or redirect configuration."
  type        = any
  default     = {}
}

variable "cors_rules" {
  description = "List of CORS rules."
  type        = any
  default     = []
}

variable "logging" {
  description = "Map containing access logging configuration: target_bucket and optional target_prefix."
  type        = any
  default     = {}
}

variable "lifecycle_rules" {
  description = "List of lifecycle rules."
  type        = any
  default     = []
}

variable "acceleration_status" {
  description = "Transfer acceleration status. Valid values are Enabled or Suspended."
  type        = string
  default     = null

  validation {
    condition     = var.acceleration_status == null || contains(["Enabled", "Suspended"], var.acceleration_status)
    error_message = "acceleration_status must be Enabled, Suspended, or null."
  }
}

variable "request_payer" {
  description = "Who pays request and data transfer costs. Valid values are BucketOwner or Requester."
  type        = string
  default     = null

  validation {
    condition     = var.request_payer == null || contains(["BucketOwner", "Requester"], var.request_payer)
    error_message = "request_payer must be BucketOwner, Requester, or null."
  }
}
