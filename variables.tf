variable "env" {
  type    = string
  default = "prod"
}

variable "cloudtrail" {
  type = string
  default = "mycloudtrails3bucket"
}

variable "ctkey" {
  type = string
  default = "us-east-1:accountid:key/mykmsidforencryptingcloudtrail"
}