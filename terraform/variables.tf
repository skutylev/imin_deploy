variable "access_key" {
    default = "AKIAI2YXZLZTOWJRF7DA"
}

variable "secret_key" { 
    default = "KC0ngGvxIOj3M7Xgyy9EDhwIsSK39QDxuC3M2gKp" 
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



