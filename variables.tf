variable "region" {
  description = "AWS region where buckets are created"
  type        = string
  default     = "us-east-1"
}

variable "project" {
  description = "Project name, used in tags"
  type        = string
  default     = "TerraformS3"
}

variable "owner" {
  description = "Team or person responsible, used in tags"
  type        = string
  default     = "DevOpsTeam"
}

variable "bucket_prefix" {
  description = "Prefix of the bucket name"
  type        = string
  default     = "terraform-demo-bucket"
}

variable "bucket_suffix" {
  description = "Unique suffix, because S3 bucket names are global"
  type        = string
  default     = "hamza-2026"
}

variable "environments" {
  description = "Environments to create a bucket for"
  type        = set(string)
  default     = ["dev"]

  validation {
    condition     = alltrue([for e in var.environments : contains(["dev", "stg", "prod"], e)])
    error_message = "Allowed environments are: dev, stg, prod."
  }
}

variable "force_destroy" {
  description = "Allow destroying a bucket even if it has objects"
  type        = bool
  default     = false
}