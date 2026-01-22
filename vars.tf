variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
  default     = "victor-blaze-app-bucket"
}

variable "env" {
  type     = string
  nullable = true
  default  = "development"
}