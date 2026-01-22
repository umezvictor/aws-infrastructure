output "bucket_name" {
  description = "S3 bucket"
  value       = aws_s3_bucket.victor-bucket.bucket
}

#Terraform prints out your output values when you run a plan or apply, and also stores them in your workspace's state file.
#value = <resource_type>.<resource_name>.<attribute>