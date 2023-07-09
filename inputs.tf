variable "var_region" {
  type        = string
  default     = "us-west-2"
  description = "Region for VPC"
}


variable "var_vpc_subnet_info" {
  type = object({
    vpc_cidr_range             = string,
    vpc_subnet_names           = list(string),
    vpc_subnet_available_zones = list(string),
    private_subnets            = list(string),
    public_subnets             = list(string),
    db_subnets                 = list(string),
    web_ec2_subnets            = string
  })
  default = {
    vpc_cidr_range             = "192.168.0.0/16"
    vpc_subnet_names           = ["app1", "app2", "db1", "db2"]
    vpc_subnet_available_zones = ["a", "b", "a", "b"]
    private_subnets            = ["app1", "app2", "db1", "db2"]
    public_subnets             = []
    db_subnets                 = ["db1", "db2"]
    web_ec2_subnets            = ""
  }
  description = "Complete information related VPC and subnets exists in this object"
}
