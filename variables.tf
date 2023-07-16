variable "db_password" {
  description = "The master password for the RDS instance"
  type        = string
}
variable "engine_version" {
  description = "The engine version of the RDS cluster"
  type        = string
  default     = "14.6"
}