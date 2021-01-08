variable "AWS_REGION" {
  default = "us-east-2"
}
variable "AWS_ACCESS_KEY" {}

variable "AWS_SECRET_KEY" {}

variable "AMIS" {
  type = map(string)
  default = {
    us-east-1 = "ami-13be557e"
    us-west-2 = "ami-06b94666"
    eu-west-1 = "ami-844e0bf7"
    us-east-2 = "ami-0a91cd140a1fc148a"
  }
}

variable "MASTER_INSTANCE_TYPE" {
  default = "t3a.medium"
}

variable "WORKER_INSTANCE_TYPE" {
  default = "t3a.medium"
}

variable "WORKER_COUNT" {}

variable "PRIVATE_KEY" {
  default = "awskey"
}

variable "PUBLIC_KEY" {
  default = "awskey.pub"
}

variable "KUBE_INTERNAL_PORTS" {
  default = [2379, 2380, 10250, 10251, 10252, 22]
}

variable "KUBE_API_PORT" {
  default = 6443
}

variable "NODE_PORT" {
  default = {
    FROM = 30000
    TO   = 32767
  }
}

variable "EXTERNAL_PORTS" {
  default = [80, 443, 22]
}

variable "S3_BUCKET" {}
