resource "aws_s3_bucket" "image_bucket" {
    # bucket        = "${var.bucket_name}" // custom name
    bucket        = "social-something-bucket-hugo" // add hugo for globally unique name
    force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "bucket_access" {
    bucket = aws_s3_bucket.image_bucket.id

    block_public_acls   = true
    block_public_policy = true
    ignore_public_acls  = true
}
