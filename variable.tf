variable "name" {}
variable "env" {}
variable "vpc_id" {}
variable "port" {
  default = 80
}
variable "sg_subnet_cidr" {}
variable "tags" {}
variable "internal" {}
variable "load_balancer_type" {}
variable "subnet_ids" {}