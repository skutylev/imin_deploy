provider "aws" {
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
    region = "${var.region}"
}

resource "aws_key_pair" "auth" {
    key_name   = "${var.key_name}"
    public_key = "${file(var.public_key_path)}"
}

resource "aws_vpc" "default" {
    cidr_block = "172.22.0.0/16"
}

resource "aws_internet_gateway" "default" {
    vpc_id = "${aws_vpc.default.id}"
}

resource "aws_route" "internet_access" {
    route_table_id         = "${aws_vpc.default.main_route_table_id}"
    destination_cidr_block = "0.0.0.0/0"
    gateway_id             = "${aws_internet_gateway.default.id}"
}

resource "aws_subnet" "subnet1" {
  vpc_id                  = "${aws_vpc.default.id}"
  cidr_block              = "172.22.1.0/24"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "subnet2" {
  vpc_id                  = "${aws_vpc.default.id}"
  cidr_block              = "172.22.2.0/24"
  map_public_ip_on_launch = true
}

resource "aws_security_group" "navi-web-sg" {
  name        = "navi-web-sg"
  description = "SG for navi-webapp"
  vpc_id      = "${aws_vpc.default.id}"

  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP access from the anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_elasticache_subnet_group" "navi-web-redis-subnet-group" {
    name = "navi-web-redis-subnet-group"
    description = "subnet group for navi-webapp redis cluster"
    subnet_ids = ["${aws_subnet.subnet1.id}", "${aws_subnet.subnet2.id}"]
}

resource "aws_elasticache_cluster" "navi-web-redis" {
    cluster_id = "navi-web-redis"
    engine = "redis"
    node_type = "cache.t2.micro"
    port = 6380
    num_cache_nodes = 1
    parameter_group_name = "default.redis2.8"
    security_group_ids = ["${aws_security_group.navi-web-sg.id}"]
    subnet_group_name = "navi-web-redis-subnet-group"
}

resource "aws_instance" "example" {
    ami = "ami-f95ef58a"
    instance_type = "t2.micro"
    vpc_security_group_ids = ["${aws_security_group.navi-web-sg.id}"]
    key_name = "${aws_key_pair.auth.id}"
    subnet_id = "${aws_subnet.subnet1.id}"
}

