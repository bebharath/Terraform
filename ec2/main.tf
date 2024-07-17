provider "aws" {
    region = "eu-north-1"
  
}

resource "aws_instance" "myec2" {
    ami = "ami-064983766e6ab3419"
    instance_type = "t3.micro" 
    security_groups = [aws_security_group.webtraffic.name]
    tags = {
      Name = "MyFirstEC2"
    }
}

variable "ingressrule" {
    type = list(number)
    default = [ 443,80 ]
  
}

variable "egressrules" {
    type = list(number)
    default = [80,443,25,8080,3306]
  
}
#resource "aws_eip" "elasticeip" {
#    instance = aws_instance.myec2.id
#      
#}
#
#output "ElasticIP" {
#    value = aws_eip.elasticeip.public_ip
#  
#}

resource "aws_security_group" "webtraffic" {
    name = "Allow HTTPS"
    
    dynamic "ingress" {
        iterator = port
        for_each = var.ingressrule
        content {
          from_port = port.value
          to_port = port.value
          protocol = "TCP"
          cidr_blocks = ["0.0.0.0/0"]
        }
      
    }

    dynamic "egress" {
        iterator = port
        for_each = var.egressrules
        content {
          from_port = port.value
          to_port = port.value
          protocol = "TCP"
          cidr_blocks = ["0.0.0.0/0"]
        }
      
    }
#    ingress  {
#        from_port = 443
#        to_port = 443
#        protocol = "TCP"
#        cidr_blocks = ["0.0.0.0/0"]
#    }
#
#    egress  {
#        from_port = 443
#        to_port = 443
#        protocol = "TCP"
#        cidr_blocks = ["0.0.0.0/0"]
#    }
  
}