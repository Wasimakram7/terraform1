var_region = "us-west-2"



var_vpc_subnet_info = {
  vpc_cidr_range             = "10.100.0.0/16"
  vpc_subnet_names           = ["app1", "app2", "db1", "db2", "web1", "web2"]
  vpc_subnet_available_zones = ["a", "b", "a", "b", "a", "b"],
  private_subnets            = ["app1", "app2", "db1", "db2"],
  public_subnets             = ["web1", "web2"],
  db_subnets                 = ["db1", "db2"],
  web_ec2_subnets            = "web1"
}
