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

variable "admin_env_id" {
  type        = string
  description = "P1 Environment containing the Worker App"
}

variable "admin_user_id" {
  type        = string
  description = "P1 Admin User to get full access to the release Env - must be in the same Env as the Worker"
}

variable "worker_id" {
  type        = string
  description = "Worker App ID App - App must have sufficient Roles"
}

variable "worker_secret" {
  type        = string
  description = "Worker App Secret - App must have sufficient Roles"
}