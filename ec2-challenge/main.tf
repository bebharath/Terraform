provider "aws" {
    region = "eu-north-1"
  
}

resource "aws_instance" "DB-Server" {
    ami = "ami-064983766e6ab3419"
    instance_type = "t3.micro"

    tags = {
      Name = "DB-Server"
    }
  
}

resource "aws_instance" "webserver" {
    ami = "ami-064983766e6ab3419"
    instance_type = "t3.micro"
    security_groups = [aws_security_group.webtraffic.name]
    tags = {
      Name = "webserver"
    }
  
}

resource "aws_eip" "webserver-ip" {
    instance = aws_instance.webserver.id
  
}

variable "ingress" {
    type = list(number)
    default = [80,443]
  
}

variable "egress" {
    type = list(number)
    default = [80,443]
  
}
resource "aws_security_group" "webtraffic" {
    name = "Allow Https"
    
    dynamic ingress {
        iterator = port
        for_each = var.ingress
        content {
            from_port = port.value
            to_port = port.value
            protocol = "TCP"
            cidr_blocks = ["0.0.0.0/0"]
        }
    }
    dynamic egress {
        iterator = port
        for_each = var.egress
        content {
            from_port = port.value
            to_port = port.value
            protocol = "TCP"
            cidr_blocks = ["0.0.0.0/0"]
        }
    }
}

output "DB-IP" {
    value = aws_instance.DB-Server.private_ip
  
}

output "webserver-ip"{
    value = aws_instance.webserver.public_ip
}
 