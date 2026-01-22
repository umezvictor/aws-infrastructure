resource "aws_s3_bucket" "victor-bucket" {
  bucket = var.bucket_name

  tags = {
    Name        = "uploads"
    Environment = var.env
  }
}