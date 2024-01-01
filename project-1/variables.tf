variable "cidr_block" {
  default = "10.0.0.0/16"
}

variable "ec2_details" {
  description = "Details of ec2 instance"
  type        = map(string)
  default = {
    ami  = "ami-06aa3f7caf3a30282"
    type = "t2.micro"
  }
}