resource "aws_security_group" "mysql_sg" {
  name   = "mysql"
  vpc_id = local.vpc_id
  ingress {
    from_port   = local.mysql_port
    to_port     = local.mysql_port
    cidr_blocks = [var.var_vpc_subnet_info.vpc_cidr_range]
    protocol    = local.tcp
  }

  tags = {
    Name = "mysql"
  }

  depends_on = [
    aws_subnet.vpc_subnets
  ]
}


data "aws_subnets" "db" {

  filter {
    name   = "tag:Name"
    values = var.var_vpc_subnet_info.db_subnets
  }

  filter {
    name   = "vpc-id"
    values = [local.vpc_id]
  }

  depends_on = [
    aws_subnet.vpc_subnets, aws_vpc.ntiervpc
  ]
}

resource "aws_db_subnet_group" "mysql_subnet_group" {
  name       = "mysql_subnets"
  subnet_ids = data.aws_subnets.db.ids

  depends_on = [
    aws_subnet.vpc_subnets
  ]
}


/*  Create DB instance*/
resource "aws_db_instance" "empdb" {
  db_name                = "ntier_empdb"
  db_subnet_group_name   = aws_db_subnet_group.mysql_subnet_group.name
  allocated_storage      = 20
  engine                 = "mysql"
  engine_version         = "8.0.28"
  username               = "admin"
  password               = "Temp1234$$"
  instance_class         = "db.t2.micro"
  publicly_accessible    = false
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.mysql_sg.id]

  depends_on = [
    aws_security_group.mysql_sg,
    aws_db_subnet_group.mysql_subnet_group
  ]
}
