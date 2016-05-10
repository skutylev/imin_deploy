variable "access_key" {
    default = "AKIAIVSCV3UVUSZQ3V4A"
}

variable "secret_key" { 
    default = "1ULBfcysbM8H1XGVUQzPCI1oHG61nhQ0v8QE58de" 
}

variable "region" {
    description = "AWS region to launch servers."
    default = "eu-west-1"
}

variable "public_key_path" {
    description = "Path for public key"
    default = "~/.ssh/id_rsa.pub"
}

variable "key_name" {
    description = "Name of ssh key pairs in AWS EC2"
    default = "navi-ssh-key"
}
