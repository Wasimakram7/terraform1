resource "aws_security_group" "web_sg" {
  name   = "web"
  vpc_id = local.vpc_id
  ingress {
    from_port   = local.ssh_port
    to_port     = local.ssh_port
    cidr_blocks = [var.var_vpc_subnet_info.vpc_cidr_range]
    protocol    = local.tcp
  }
  ingress {
    from_port   = local.http_port
    to_port     = local.http_port
    cidr_blocks = [var.var_vpc_subnet_info.vpc_cidr_range]
    protocol    = local.tcp
  }


  tags = {
    Name = "websecuritygroup"
  }

  depends_on = [
    aws_subnet.vpc_subnets
  ]
}


data "aws_ami_ids" "ubuntu_ami_id" {
  owners = ["099720109477"]
  filter {
    name   = "description"
    values = ["Canonical, Ubuntu, 22.04 LTS, amd64 jammy image build on 2023-03-25"]
  }
  filter {
    name   = "is-public"
    values = ["true"]
  }
}

data "aws_subnet" "web1_subnet" {
  vpc_id = local.vpc_id
  filter {
    name   = "tag:Name"
    values = [var.var_vpc_subnet_info.web_ec2_subnets]
  }

  depends_on = [
    aws_subnet.vpc_subnets
  ]
}

resource "aws_instance" "web1_ec2_instance" {
  ami                         = data.aws_ami_ids.ubuntu_ami_id.ids[0]
  associate_public_ip_address = true
  instance_type               = "t2.micro"
  subnet_id                   = data.aws_subnet.web1_subnet.id
  vpc_security_group_ids      = [aws_security_group.web_sg.id]
  tags = {
    Name = "Web 1"
  }
  depends_on = [
    aws_db_instance.empdb, aws_security_group.web_sg
  ]
}
