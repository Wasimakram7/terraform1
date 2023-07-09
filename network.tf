# create a VPC
resource "aws_vpc" "ntiervpc" {
  cidr_block = var.var_vpc_subnet_info.vpc_cidr_range
  tags = {
    Name        = "ntier-VPC"
    Environment = "Dev"
  }
}


# Create subnets
resource "aws_subnet" "vpc_subnets" {
  count             = length(var.var_vpc_subnet_info.vpc_subnet_names)
  vpc_id            = aws_vpc.ntiervpc.id
  availability_zone = "${var.var_region}${var.var_vpc_subnet_info.vpc_subnet_available_zones[count.index]}"

  cidr_block = cidrsubnet(var.var_vpc_subnet_info.vpc_cidr_range, 8, count.index)
  tags = {
    Name = var.var_vpc_subnet_info.vpc_subnet_names[count.index]
  }
  depends_on = [
    aws_vpc.ntiervpc
  ]
}


# Internet gateway
resource "aws_internet_gateway" "ntier_igw" {
  vpc_id = local.vpc_id
  tags = {
    Name = "ntier-igw"
  }
  depends_on = [
    aws_vpc.ntiervpc
  ]
}

resource "aws_route_table" "private_route" {
  vpc_id = local.vpc_id

  tags = {
    Name = "PrivateRouteTable"
  }

  depends_on = [
    aws_subnet.vpc_subnets
  ]
}

resource "aws_route_table" "public_route" {
  vpc_id = local.vpc_id

  route {
    cidr_block = local.anywhere
    gateway_id = aws_internet_gateway.ntier_igw.id
  }

  tags = {
    Name = "PublicRouteTable"
  }

  depends_on = [
    aws_subnet.vpc_subnets
  ]
}

/* Data querying the already created public subnets, while referring to their names(web1, web2) as given in inputs */
data "aws_subnets" "public" {

  filter {
    name   = "tag:Name"
    values = var.var_vpc_subnet_info.public_subnets
  }
  filter {
    name   = "vpc-id"
    values = [local.vpc_id]
  }
  depends_on = [
    aws_subnet.vpc_subnets, aws_vpc.ntiervpc
  ]
}


/*  Public route table association  */
resource "aws_route_table_association" "public_association" {
  count          = length(data.aws_subnets.public.ids)
  route_table_id = aws_route_table.public_route.id
  subnet_id      = data.aws_subnets.public.ids[count.index]
}


/* Data querying the already created private subnets, while referring to their names(app1, app2, db1, db2) as given in inputs */
data "aws_subnets" "private" {

  filter {
    name   = "tag:Name"
    values = var.var_vpc_subnet_info.private_subnets
  }
  filter {
    name   = "vpc-id"
    values = [local.vpc_id]
  }

  depends_on = [
    aws_subnet.vpc_subnets, aws_vpc.ntiervpc
  ]
}

/*  Private route table association  */
resource "aws_route_table_association" "private_association" {
  count          = length(data.aws_subnets.private.ids)
  route_table_id = aws_route_table.private_route.id
  subnet_id      = data.aws_subnets.private.ids[count.index]
}
