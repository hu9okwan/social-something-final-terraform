resource "aws_s3_bucket" "image_bucket" {
    bucket        = "${var.bucket_name}"
    force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "bucket_access" {
    bucket = var.bucket_name

    block_public_acls   = true
    block_public_policy = true
    ignore_public_acls  = true
}
