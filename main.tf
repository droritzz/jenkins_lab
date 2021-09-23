provider "aws" {
  profile = "default"
  region  = var.region
}

resource "aws_vpc" "srv_vpc" {
  cidr_block = var.cidr_block
  tags = {
    Name = "jenkins_srv"
  }
}

resource "aws_subnet" "srv_subnet" {
  vpc_id            = aws_vpc.srv_vpc.id
  cidr_block        = var.cidr_block
  availability_zone = var.subnet_zone

  tags = {
    Name = "subnet terraform"
  }
}

resource "aws_security_group" "srv_security_group" {
  name   = "srv_security_group"
  vpc_id = aws_vpc.srv_vpc.id

  ingress = [
    {
      description      = "security group inbound rule for SSH"
      from_port   = 22
      to_port     = 22
      protocol    = "TCP"
      cidr_blocks = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      self = null
      prefix_list_ids= null
      security_groups=null
    },
    {
      description      = "security group inbound rule for Jenkins"
      from_port   = 8080
      to_port     = 8080
      protocol    = "TCP"
      cidr_blocks = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      self = null
      prefix_list_ids= null
      security_groups= null
    }
  ]
  egress = [
    {
      from_port   = 0
      to_port     = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      self = null
      prefix_list_ids= null
      security_groups= null
      description = "security group outbound rule"

    }
  ]

  tags = {
    Name = "srv_security_group"
  }
}

resource "aws_internet_gateway" "gateway"{
  vpc_id = aws_vpc.srv_vpc.id
}

resource "aws_subnet" "srv_public_subnet" {
    vpc_id = aws_vpc.srv_vpc.id

    cidr_block = var.cidr_block
    availability_zone = var.subnet_zone
    tags= {
        Name = "Public Subnet"
    }
}

resource "aws_route_table" "srv_route_table" {
    vpc_id = aws_vpc.srv_vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.gateway.id 
    }

    tags = {
        Name = "Public Subnet"
    }
}

resource "aws_route_table_association" "my_route_table_assoc" {
    subnet_id = aws_subnet.srv_public_subnet.id
    route_table_id = aws_route_table.srv_route_table.id 
}

resource "aws_network_interface" "master_ip" {
  subnet_id   = aws_subnet.srv_subnet.id
  security_groups = [aws_security_group.srv_security_group.id]

  attachment {
    instance = aws_instance.master.id
    device_index = 1
  }

  tags = {
    Name = "primary_network_interface_jenkins_master"
  }
}

resource "aws_network_interface" "slave_ip" {
  subnet_id   = aws_subnet.srv_subnet.id
  security_groups = [aws_security_group.srv_security_group.id]

  attachment {
    instance = aws_instance.slave.id
    device_index = 1
  }
 
  tags = {
    Name = "primary_network_interface_jenkins_slave"
  }
}

resource "aws_instance" "master" {
  ami           = var.ami
  instance_type = var.machine_type
  key_name = var.key_name
  associate_public_ip_address = "true"
  vpc_security_group_ids = [aws_security_group.srv_security_group.id]
  subnet_id = aws_subnet.srv_subnet.id
  
  tags = {
    Name = "jenkins master "
  }
}

resource "aws_instance" "slave" {
  ami           = var.ami
  instance_type = var.machine_type
  key_name = var.key_name
  associate_public_ip_address = "true"
  vpc_security_group_ids = [aws_security_group.srv_security_group.id]
  subnet_id = aws_subnet.srv_subnet.id
 
  tags = {
    Name = "jenkins slave "
  }
}