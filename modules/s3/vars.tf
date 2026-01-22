variable "env" {
  description = "The environment for which the bucket is created (e.g., development, staging, production)"
  type        = string
  default     = "development"
}

variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
}

