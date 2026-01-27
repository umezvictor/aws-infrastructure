variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
  default     = "victor-blaze-app-bucket"
}

variable "env" {
  type     = string
  nullable = true
  default  = "production"
}

variable "cidr" {
  type        = string
  default     = "10.10.0.0/16"
  description = "VPC CIDR"
}

variable "public_subnets" {
  type        = list(string)
  default     = ["10.10.50.0/24", "10.10.51.0/24"]
  description = "Public subnets"
}