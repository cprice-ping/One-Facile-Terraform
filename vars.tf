variable "region" {
  type        = string
  description = "Region your P1 Org is in"
}

variable "org_id" {
  type        = string
  description = "Organization ID"
}

variable "env_name" {
  type        = string
  description = "Environment Name"
}

variable "env_id" {
  type        = string
  description = "P1 Environment containing the Worker App"
}

variable "worker_id" {
  type        = string
  description = "Worker App ID App - App must have sufficient Roles"
}

variable "worker_secret" {
  type        = string
  description = "Worker App Secret - App must have sufficient Roles"
}