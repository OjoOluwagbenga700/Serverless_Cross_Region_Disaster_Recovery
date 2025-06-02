
variable "pri_region" {
  description = "Primary AWS region"
  type        = string
  default     = "us-east-1"
}
variable "sec_region" {
  description = "Secondary AWS region"
  type        = string
  default     = "us-east-2"
}
variable "table_name" {
  description = "DynamoDB table name"
  type        = string
  default     = "HighAvailabilityTable"
}
variable "domain_name" {
  description = "domain name for API Gateway"
  type        = string
  default     = "7hundredtechnologies.com"
}


