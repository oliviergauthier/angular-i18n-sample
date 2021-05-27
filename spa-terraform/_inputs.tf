variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "route53_zone_name" {
  description = "route 53 zone name"
}
