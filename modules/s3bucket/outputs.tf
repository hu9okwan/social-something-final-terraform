// maybe output bucket id or name?

output "bucket_name" {
    value = aws_s3_bucket.image_bucket.id
}


output "bucket_region" {
    value = aws_s3_bucket.image_bucket.region
}
