variable "domain_name" {
  description = "Custom domain name for Route 53"
  type        = string
  default     = "example.com"
  
}

variable "apigw_primary_domain_name_target" {
  description = "API Gateway primary domain name target"
  type        = string
}

variable "apigw_primary_domain_name_zone_id" {
  description = "API Gateway primary domain name zone ID"
  type        = string
}

variable "apigw_secondary_domain_name_target" {
  description = "API Gateway secondary domain name target"
  type        = string
}
variable "apigw_secondary_domain_name_zone_id" {
  description = "API Gateway secondary domain name zone ID"
  type        = string
}