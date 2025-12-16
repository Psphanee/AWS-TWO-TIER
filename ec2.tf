resource "aws_instance" "web" {
  count           = 2
  ami             = "ami-0c02fb55956c7d316"
  instance_type   = "t3.micro"
  subnet_id       = aws_subnet.public[count.index].id
  security_groups = [aws_security_group.web_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "Web Server ${count.index}" > /var/www/html/index.html
              EOF
}
