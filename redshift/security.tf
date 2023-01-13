variable "my_ip" {}

resource "aws_vpc" "my_cluster" {
  cidr_block = "11.0.0.0/22"
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.my_cluster.id
}

resource "aws_subnet" "my_cluster" {
  cidr_block              = "11.0.0.0/22"
  vpc_id                  = aws_vpc.my_cluster.id
  availability_zone       = "eu-west-1a"
  map_public_ip_on_launch = true
}

resource "aws_redshift_subnet_group" "my_cluster" {
  name = "my-cluster"
  subnet_ids = [
    aws_subnet.my_cluster.id,
  ]
}

resource "aws_route_table" "my_cluster_to_the_internet" {
  vpc_id = aws_vpc.my_cluster.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }
}

resource "aws_route_table_association" "my_cluster_to_the_internet" {
  route_table_id = aws_route_table.my_cluster_to_the_internet.id
  subnet_id      = aws_subnet.my_cluster.id
}

resource "aws_default_security_group" "my_cluster" {
  vpc_id = aws_vpc.my_cluster.id

  ingress {
    from_port = 5439
    to_port   = 5439
    protocol  = "tcp"
    cidr_blocks = [
      "${var.my_ip}/32"
    ]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    ipv6_cidr_blocks = [
      "::/0"
    ]
  }
}
