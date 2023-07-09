locals {
  vpc_id     = aws_vpc.ntiervpc.id
  anywhere   = "0.0.0.0/0"
  mysql_port = 3306
  tcp        = "tcp" # protocol
  http_port  = 80
  ssh_port   = 22
  https_port = 443
}
