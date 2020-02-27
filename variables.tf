variable "animal" {
  type        = string
  description = "A unique identifier for each DPG guest. Set as a variable in Terraform Cloud."
}

variable "env" {
  type        = string
  description = "The environment ('prod' or 'staging'). Set as a variable in Terraform Cloud."
}

variable "r53-zone" {
  default     = "february.ldn.devopsplayground.com"
  type        = string
  description = "The (existing) Route 53 hosted zone in which to create A-records. (Omit trailing dot.)"
}
