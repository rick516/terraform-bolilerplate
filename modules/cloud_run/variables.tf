variable "project_id" {
  description = "The ID of the project in which resources will be managed."
  type        = string
}

variable "region" {
  description = "The region in which resources will be managed."
  type        = string
}

variable "name" {
  description = "The name of the Cloud Run service."
  type        = string
}

variable "image" {
  description = "The Docker image to deploy to Cloud Run."
  type        = string
}

variable "cpu" {
  description = "The amount of CPU allocated to the Cloud Run service."
  type        = string
  default     = "1000m"
}

variable "memory" {
  description = "The amount of memory allocated to the Cloud Run service."
  type        = string
  default     = "256Mi"
}

variable "max_instances" {
  description = "The maximum number of instances for the Cloud Run service."
  type        = number
  default     = 10
}

variable "custom_domain" {
  description = "The custom domain to map to the Cloud Run service."
  type        = string
  default     = ""
}