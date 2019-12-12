provider "aws" {
 access_key  = "AKIARAQAG4VF2CVL4YVT"
  secret_key  = "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"
   region = "us-east-1"
}

resource "aws_instance" "terraform" {
  ami = "ami-04b9e92b5572fa0d1"
  instance_type = "t2.micro"
  key_name = "ec2keys"
  user_data = "${file("install_apache.sh")}"
}
resource "aws_security_group" "instance" { 
  name = "inlets-server-instance1" 
  description = "inlets-server-instance " 
  ingress { 
    from_port = 22 
    to_port = 22 
    protocol = "tcp" 
    cidr_blocks = ["0.0.0.0/0"] 
  } 

  egress { 
    from_port = 0 
    to_port = 0 
    protocol = "-1" 
    cidr_blocks = ["0.0.0.0/0"] 
  } 
}
output "public_dns" {
   description = "public dns ip"
   value = aws_instance.terraform.*.public_ip
}

