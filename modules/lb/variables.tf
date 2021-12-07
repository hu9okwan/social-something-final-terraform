# Put variables in here
# This is data coming from the root module
# So any arguments that are currently commented out


variable "security_groups" {
    description = "security groups"
    type        = string
}

variable "subnets" {
    description = "subnets"
    type        = list
}

variable "vpc_id" {
    description = "Vpc id"
    type        = string
}

variable "certificate_arn" {
    description = "The ARN of the certificate that is being validated"
    type        = string
}