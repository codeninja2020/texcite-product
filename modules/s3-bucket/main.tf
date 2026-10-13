locals {
  bucket_name = var.bucket_name != null ? var.bucket_name : var.bucket

  create_bucket                  = var.create_bucket
  create_public_access_block     = local.create_bucket && var.create_public_access_block
  create_ownership_controls      = local.create_bucket && var.object_ownership != null
  create_acl                     = local.create_bucket && var.acl != null && var.object_ownership != "BucketOwnerEnforced"
  create_encryption              = local.create_bucket && var.encryption_enabled
  versioning_enabled             = var.versioning != null ? var.versioning.enabled : var.versioning_enabled
  create_versioning              = local.create_bucket && local.versioning_enabled != null
  create_policy                  = local.create_bucket && var.attach_policy && var.policy != null
  create_website_configuration   = local.create_bucket && length(keys(var.website)) > 0
  create_cors_configuration      = local.create_bucket && length(var.cors_rules) > 0
  create_logging                 = local.create_bucket && length(keys(var.logging)) > 0
  create_lifecycle_configuration = local.create_bucket && length(var.lifecycle_rules) > 0
  create_acceleration            = local.create_bucket && var.acceleration_status != null
  create_request_payment         = local.create_bucket && var.request_payer != null
}

resource "aws_s3_bucket" "this" {
  count = local.create_bucket ? 1 : 0

  bucket              = local.bucket_name
  bucket_prefix       = var.bucket_prefix
  force_destroy       = var.force_destroy
  object_lock_enabled = var.object_lock_enabled
  tags                = var.tags
}

resource "aws_s3_bucket_public_access_block" "this" {
  count = local.create_public_access_block ? 1 : 0

  bucket = aws_s3_bucket.this[0].id

  block_public_acls       = var.block_public_acls
  block_public_policy     = var.block_public_policy
  ignore_public_acls      = var.ignore_public_acls
  restrict_public_buckets = var.restrict_public_buckets
}

resource "aws_s3_bucket_ownership_controls" "this" {
  count = local.create_ownership_controls ? 1 : 0

  bucket = aws_s3_bucket.this[0].id

  rule {
    object_ownership = var.object_ownership
  }

  depends_on = [aws_s3_bucket_public_access_block.this]
}

resource "aws_s3_bucket_acl" "this" {
  count = local.create_acl ? 1 : 0

  bucket                = aws_s3_bucket.this[0].id
  acl                   = var.acl
  expected_bucket_owner = var.expected_bucket_owner

  depends_on = [aws_s3_bucket_ownership_controls.this]
}

resource "aws_s3_bucket_policy" "this" {
  count = local.create_policy ? 1 : 0

  bucket = aws_s3_bucket.this[0].id
  policy = var.policy

  depends_on = [aws_s3_bucket_public_access_block.this]
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  count = local.create_encryption ? 1 : 0

  bucket                = aws_s3_bucket.this[0].id
  expected_bucket_owner = var.expected_bucket_owner

  rule {
    bucket_key_enabled = var.bucket_key_enabled

    apply_server_side_encryption_by_default {
      sse_algorithm     = var.sse_algorithm
      kms_master_key_id = var.kms_master_key_id
    }
  }
}

resource "aws_s3_bucket_versioning" "this" {
  count = local.create_versioning ? 1 : 0

  bucket                = aws_s3_bucket.this[0].id
  expected_bucket_owner = var.expected_bucket_owner
  mfa                   = var.versioning_mfa

  versioning_configuration {
    status     = local.versioning_enabled ? "Enabled" : "Suspended"
    mfa_delete = var.versioning_mfa_delete
  }
}

resource "aws_s3_bucket_website_configuration" "this" {
  count = local.create_website_configuration ? 1 : 0

  bucket                = aws_s3_bucket.this[0].id
  expected_bucket_owner = var.expected_bucket_owner

  dynamic "index_document" {
    for_each = try([var.website.index_document], [])

    content {
      suffix = index_document.value
    }
  }

  dynamic "error_document" {
    for_each = try([var.website.error_document], [])

    content {
      key = error_document.value
    }
  }

  dynamic "redirect_all_requests_to" {
    for_each = try([var.website.redirect_all_requests_to], [])

    content {
      host_name = redirect_all_requests_to.value.host_name
      protocol  = try(redirect_all_requests_to.value.protocol, null)
    }
  }

  dynamic "routing_rule" {
    for_each = try(var.website.routing_rules, [])

    content {
      dynamic "condition" {
        for_each = try([routing_rule.value.condition], [])

        content {
          http_error_code_returned_equals = try(condition.value.http_error_code_returned_equals, null)
          key_prefix_equals               = try(condition.value.key_prefix_equals, null)
        }
      }

      redirect {
        host_name               = try(routing_rule.value.redirect.host_name, null)
        http_redirect_code      = try(routing_rule.value.redirect.http_redirect_code, null)
        protocol                = try(routing_rule.value.redirect.protocol, null)
        replace_key_prefix_with = try(routing_rule.value.redirect.replace_key_prefix_with, null)
        replace_key_with        = try(routing_rule.value.redirect.replace_key_with, null)
      }
    }
  }
}

resource "aws_s3_bucket_cors_configuration" "this" {
  count = local.create_cors_configuration ? 1 : 0

  bucket                = aws_s3_bucket.this[0].id
  expected_bucket_owner = var.expected_bucket_owner

  dynamic "cors_rule" {
    for_each = var.cors_rules

    content {
      id              = try(cors_rule.value.id, null)
      allowed_headers = try(cors_rule.value.allowed_headers, null)
      allowed_methods = cors_rule.value.allowed_methods
      allowed_origins = cors_rule.value.allowed_origins
      expose_headers  = try(cors_rule.value.expose_headers, null)
      max_age_seconds = try(cors_rule.value.max_age_seconds, null)
    }
  }
}

resource "aws_s3_bucket_logging" "this" {
  count = local.create_logging ? 1 : 0

  bucket                = aws_s3_bucket.this[0].id
  expected_bucket_owner = var.expected_bucket_owner
  target_bucket         = var.logging.target_bucket
  target_prefix         = try(var.logging.target_prefix, null)
}

resource "aws_s3_bucket_lifecycle_configuration" "this" {
  count = local.create_lifecycle_configuration ? 1 : 0

  bucket                = aws_s3_bucket.this[0].id
  expected_bucket_owner = var.expected_bucket_owner

  dynamic "rule" {
    for_each = var.lifecycle_rules

    content {
      id     = try(rule.value.id, null)
      status = try(rule.value.enabled, true) ? "Enabled" : "Disabled"

      dynamic "abort_incomplete_multipart_upload" {
        for_each = try(rule.value.abort_incomplete_multipart_upload_days, null) == null ? [] : [rule.value.abort_incomplete_multipart_upload_days]

        content {
          days_after_initiation = abort_incomplete_multipart_upload.value
        }
      }

      dynamic "expiration" {
        for_each = try([rule.value.expiration], [])

        content {
          date                         = try(expiration.value.date, null)
          days                         = try(expiration.value.days, null)
          expired_object_delete_marker = try(expiration.value.expired_object_delete_marker, null)
        }
      }

      dynamic "transition" {
        for_each = try(rule.value.transition, [])

        content {
          date          = try(transition.value.date, null)
          days          = try(transition.value.days, null)
          storage_class = transition.value.storage_class
        }
      }

      dynamic "noncurrent_version_expiration" {
        for_each = try([rule.value.noncurrent_version_expiration], [])

        content {
          newer_noncurrent_versions = try(noncurrent_version_expiration.value.newer_noncurrent_versions, null)
          noncurrent_days           = try(noncurrent_version_expiration.value.noncurrent_days, noncurrent_version_expiration.value.days, null)
        }
      }

      dynamic "noncurrent_version_transition" {
        for_each = try(rule.value.noncurrent_version_transition, [])

        content {
          newer_noncurrent_versions = try(noncurrent_version_transition.value.newer_noncurrent_versions, null)
          noncurrent_days           = try(noncurrent_version_transition.value.noncurrent_days, noncurrent_version_transition.value.days, null)
          storage_class             = noncurrent_version_transition.value.storage_class
        }
      }

      dynamic "filter" {
        for_each = try([rule.value.filter], [{}])

        content {
          prefix                   = try(filter.value.prefix, null)
          object_size_greater_than = try(filter.value.object_size_greater_than, null)
          object_size_less_than    = try(filter.value.object_size_less_than, null)

          dynamic "tag" {
            for_each = try([filter.value.tag], [])

            content {
              key   = tag.value.key
              value = tag.value.value
            }
          }
        }
      }
    }
  }

  depends_on = [aws_s3_bucket_versioning.this]
}

resource "aws_s3_bucket_accelerate_configuration" "this" {
  count = local.create_acceleration ? 1 : 0

  bucket                = aws_s3_bucket.this[0].id
  expected_bucket_owner = var.expected_bucket_owner
  status                = var.acceleration_status
}

resource "aws_s3_bucket_request_payment_configuration" "this" {
  count = local.create_request_payment ? 1 : 0

  bucket                = aws_s3_bucket.this[0].id
  expected_bucket_owner = var.expected_bucket_owner
  payer                 = var.request_payer
}
