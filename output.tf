output "vpc_id" {
  value = aws_vpc.ntiervpc.id
}

###  Try prinintg all the subnet Ids. This is one way
/***
output "public_subnets" {
  value = {
    # name       = "All public subnets"
    public_subnet_ids = flatten([for i in data.aws_subnets.public[*] : i.ids[*]])
  }
}
****/

output "private_subnets" {
  value = join(", ", data.aws_subnets.private.ids)
}

output "public_subnets" {
  value = join(", ", data.aws_subnets.public.ids)
}

output "internet_gateway_id" {
  value = aws_internet_gateway.ntier_igw.id
}

output "security_group_id" {
  value = aws_security_group.mysql_sg.id
}

output "database_subnets" {
  value = join(", ", data.aws_subnets.db.ids)
}

output "mysqldb_endpoint" {
  value = aws_db_instance.empdb.endpoint
}


output "ubuntu_ami_id" {
  value = data.aws_ami_ids.ubuntu_ami_id.ids[0]
}

output "web1_public_ip" {
  value = aws_instance.web1_ec2_instance.public_ip
}
