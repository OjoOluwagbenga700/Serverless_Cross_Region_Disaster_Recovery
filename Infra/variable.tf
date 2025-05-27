
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
variable "custom_domain_name" {
  description = "Custom domain name for API Gateway"
  type        = string
  default     = "api.example.com"
}


variable "domain_name" {
  description = "Custom domain name for Route 53"
  type        = string
  default     = "example.com"

}