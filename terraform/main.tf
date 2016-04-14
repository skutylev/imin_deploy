provider "aws" {
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
    region = "${var.region}"
}

resource "aws_key_pair" "${var.name}-key-pair" {
    key_name   = "${var.key_name}"
    public_key = "${file(var.public_key_path)}"
}

resource "aws_vpc" "${var.name}-vpc" {
    cidr_block = "${var.cidr}"    
    enable_dns_hostnames = "${var.enable_dns_hostnames}"
    enable_dns_support = "${var.enable_dns_support}"
    tags { Name = "${var.name}" }
}

resource "aws_internet_gateway" "default" {
    vpc_id = "${aws_vpc.default.id}"
}

resource "aws_route_table" "public" {
   vpc_id = "${aws_vpc.mod.id}"
   tags { Name = "${var.name}-public" }
}

resource "aws_route" "public_internet_gateway" {
    route_table_id = "${aws_route_table.public.id}"
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.mod.id}"
}

resource "aws_route_table" "private" {
  vpc_id = "${aws_vpc.mod.id}"
  tags { Name = "${var.name}-private" }
}

resource "aws_subnet" "private" {
  vpc_id = "${aws_vpc.mod.id}"
  cidr_block = "${element(split(",", var.private_subnets), count.index)}"
  availability_zone = "${element(split(",", var.azs), count.index)}"
  count = "${length(compact(split(",", var.private_subnets)))}"
  tags { Name = "${var.name}-private" }
}

resource "aws_subnet" "public" {
  vpc_id = "${aws_vpc.mod.id}"
  cidr_block = "${element(split(",", var.public_subnets), count.index)}"
  availability_zone = "${element(split(",", var.azs), count.index)}"
  count = "${length(compact(split(",", var.public_subnets)))}"
  tags { Name = "${var.name}-public" }

  map_public_ip_on_launch = true
}

resource "aws_route_table_association" "private" {
  count = "${length(compact(split(",", var.private_subnets)))}"
  subnet_id = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id = "${aws_route_table.private.id}"
}

resource "aws_route_table_association" "public" {
  count = "${length(compact(split(",", var.public_subnets)))}"
  subnet_id = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${aws_route_table.public.id}"
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