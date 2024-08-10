variable "project_id" {
  description = "The ID of the project in which resources will be managed."
  type        = string
}

variable "service_account_email" {
  description = "The email of the service account to be used."
  type        = string
}

variable "custom_role_id" {
  description = "The ID of the custom IAM role for Cloud Run invoker."
  type        = string
  default     = "customCloudRunInvoker"
}