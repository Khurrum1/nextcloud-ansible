variable "region" {
  type    = string
  default = "eu-west-2"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "ami_prefix" {
  type    = string
  default = "code-club-AMI"
}

variable "environment" {
  description = "The environment"
  default     = "codeclub"
}



