#create subneta for rds instance 
resource "aws_subnet" "subneta" {
  vpc_id                  = aws_vpc.rds_vpc.id
  cidr_block              = "${var.subneta_cidr}"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1b" 
}

#create subnetb for rds instance 
resource "aws_subnet" "subnetb" {
  vpc_id                  = aws_vpc.rds_vpc.id
  cidr_block              = "${var.subnetb_cidr}"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1c" 
}


#create rds subnet grooup
resource "aws_db_subnet_group" "private_subnetg" {
  name        = "subnet-group"
  description = "Terraform example RDS subnet group"
  subnet_ids  = [aws_subnet.subneta.id, aws_subnet.subnetb.id]
}
 
 #create rds security group 
resource "aws_security_group" "rds" {
  name        = "rds"
  description = "Terraform example RDS MySQL server"
  vpc_id      = aws_vpc.rds_vpc.id
  # Keepllowing traffic from the web server. the instance private by only a
  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.project_sg.id]
  }
  # Allow all outbound traffic.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "rds-security-group"
  }
}

#create rds instance
resource "aws_db_instance" "default" {
  identifier                = "project-rds"
  allocated_storage         = 200
  engine                    = "mysql"
  engine_version            = "8.0.31"
  instance_class            = "db.t2.micro"
  db_name                   = "applicationdb"
  username                  = "${var.database_username}"
  password                  = "${var.database_password}"
  db_subnet_group_name      = aws_db_subnet_group.private_subnetg.name
  vpc_security_group_ids    = [aws_security_group.rds.id]
  skip_final_snapshot       = true
  
}