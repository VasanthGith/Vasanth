provider "aws" {
  region = "us-east-1"
}
resource "aws_instance" "test_instance" {
    ami = "ami-0866a3c8686eaeeba"
    instance_type = "t2.micro"
    key_name = "devops"
    vpc_security_group_ids = [ aws_security_group.demo-sg.id ]
    subnet_id = aws_subnet.myproj-pub_subnet-01.id
    for_each = toset(["Jenkins-master","build-slave","ansible"])
    tags = {
      Name = "${each.key}"
    }
//    security_groups = [ "demo-sg" ]
}

resource "aws_security_group" "demo-sg" {
  name        = "demo-sg"
  vpc_id = aws_vpc.myproj-vpc.id
  description = "Allow TLS inbound traffic and all outbound traffic"
  
  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
    ingress {
    description      = "Jenkins port"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "security_group_tag"
  }
}

resource "aws_vpc" "myproj-vpc" {
    cidr_block = "10.1.0.0/16"
    tags = {
      Name = "myproj-vpc"
    }
  
}

resource "aws_subnet" "myproj-pub_subnet-01" {
    vpc_id = aws_vpc.myproj-vpc.id
    cidr_block = "10.1.1.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = "us-east-1a"
    tags = {
      Name = "myproj-pub_subnet-01"
    }
}

resource "aws_subnet" "myproj-pub_subnet-02" {
    vpc_id = aws_vpc.myproj-vpc.id
    cidr_block = "10.1.2.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = "us-east-1b"
    tags = {
      Name = "myproj-pub_subnet-02"
    }
}

resource "aws_internet_gateway" "myproj-igw" {
  vpc_id = aws_vpc.myproj-vpc.id
  tags = {
    name = "myproj-igw"
  }
}

resource "aws_route_table" "myproj-pub-rt" {
    vpc_id = aws_vpc.myproj-vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.myproj-igw.id
    }
  
}

resource "aws_route_table_association" "myproj-rta-pub_subnet-01" {
    subnet_id = aws_subnet.myproj-pub_subnet-01.id
    route_table_id = aws_route_table.myproj-pub-rt.id
 
}

resource "aws_route_table_association" "myproj-rta-pub_subnet-02" {
    subnet_id = aws_subnet.myproj-pub_subnet-02.id
    route_table_id = aws_route_table.myproj-pub-rt.id
 
}