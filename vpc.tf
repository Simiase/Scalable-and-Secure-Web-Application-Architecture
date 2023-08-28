#create vpc for the ec2 instance
resource "aws_vpc" "rds_vpc" {
cidr_block                = "${var.vpc_cidr}"


}

#create security group for ec2 instance 
resource "aws_security_group" "project_sg" {
  name                    = "project_sg"
  description             = "Allow access on port 80 and 22"
  vpc_id                  = aws_vpc.rds_vpc.id

#allow access on port 80
  ingress {
    description           = "http access"
    from_port             = 80
    to_port               = 80
    protocol              = "tcp"
    cidr_blocks           = ["0.0.0.0/0"]
  }
   ingress {
    description           = "https access"
    from_port             = 443
    to_port               = 443
    protocol              = "tcp"
    cidr_blocks           = ["0.0.0.0/0"]
  }



# allow access on port 22
  ingress {
    description           = "ssh access"
    from_port             = 22
    to_port               = 22
    protocol              = "tcp"
    cidr_blocks           =["0.0.0.0/0"]
  }

  egress {
    from_port             = 0
    to_port               = 0
    protocol              = "-1"
    cidr_blocks           = ["0.0.0.0/0"]
  }
}

#create internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id                  = aws_vpc.rds_vpc.id
}

#create route table
resource "aws_route_table" "route_table" {
  vpc_id                  = aws_vpc.rds_vpc.id

  route {
    cidr_block            = "${var.routetable}"
    gateway_id            = aws_internet_gateway.igw.id
  }
}

#create subnetc
resource "aws_subnet" "subnetc" {
  vpc_id                  = aws_vpc.rds_vpc.id
  cidr_block              = "${var.subnetc_cidr}"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a" 
}


#create route table assocoattion for subnetc
resource "aws_route_table_association" "subnetc_association" {
  subnet_id      = aws_subnet.subnetc.id
  route_table_id = aws_route_table.route_table.id
}

#create subnetd
resource "aws_subnet" "subnetd" {
  vpc_id                  = aws_vpc.rds_vpc.id
  cidr_block              = "${var.subnetd_cidr}"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1d" 
}

#create route table assocoattion for subnetd
resource "aws_route_table_association" "subnetd_association" {
  subnet_id      = aws_subnet.subnetd.id
  route_table_id = aws_route_table.route_table.id
}

