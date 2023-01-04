variable "REGION" {
  default = "eu-north-1"
}

variable "ZONE1" {
  default = "eu-north-1a"
}

variable "ZONE2" {
  default = "eu-north-1b"
}

variable "ZONE3" {
  default = "eu-north-1c"
}

variable "AMIS" {
  type = map(any)
  default = {
    eu-north-1 = "ami-0cf1dfc38e4c28f7d"
    # eu-north-1 = "ami-0947d2ba12ee1ff75"
  }
}

variable "USER" {
  default = "ec2-user"
}

variable "PUB_KEY" {
  default = "terrakey.pub"
}

variable "PRIV_KEY" {
  default = "terrakey"
}

variable "MYIP" {
  default = "115.98.14.182/32"
}