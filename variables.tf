variable "vpc_cidr" {
default       = "10.0.0.0/16"
description   = "vpc cidr block"
type          = string
}

variable "subnetc_cidr" {
default       = "10.0.6.0/24"
description   = "subnet cidr block"
type          = string
}


variable "subnetd_cidr" {
default       = "10.0.9.0/24"
description   = "subnet cidr block"
type          = string
}

variable "subneta_cidr" {
default       = "10.0.7.0/24"
description   = "subnet cidr block"
type          = string
}

variable "subnetb_cidr" {
default       = "10.0.5.0/24"
description   = "subnet cidr block"
type          = string
}

variable "routetable" {
default       = "0.0.0.0/0"
description   = "route table. cidr"
type          = string
}


variable "egress" {
default     = "0.0.0.0/0"
description = "egress ingress"
type        = string
}

variable "availability_zones" {
  default   = ["us-east-1a", "us-east-1b" , "us-east-1c", "us-east-1d"] # Update this list with your desired availability zones
}

variable "key_name" {
default = "ec2key"
type    = string 
}


variable "database_username" {
default = "simile"
type    = string 
  
}

variable "database_password" {
default = "s1m1leoluwa123"
type    = string 
  
}

variable "ami_id" {
        description = "The AMI to use"
        default = "ami-0f34c5ae932e6f0e4"
}

variable "domain_name" {
type    = string
default  = "asenugasimileoluwa.com"
  
}