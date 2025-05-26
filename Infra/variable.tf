
variable "pri_region" {
  description = "Primary AWS region"
  type        = string
  default     = "us-east-1"
}
variable "sec_region" {
  description = "Secondary AWS region"
  type        = string
  default     = "us-west-2"
}
variable "table_name" {
  description = "DynamoDB table name"
  type        = string
  default     = "HighAvailabilityTable"
}
