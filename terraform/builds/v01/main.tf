# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
# @@@@@@ Prerequesits ~ START @@@@@@
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

# Any requirments needed for this applicatin to run exists in here.

# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
# @@@@@@@ Prerequesits ~ END @@@@@@@
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

provider "aws" {
  # version                 = "~> 2.8"
  region                  = var.aws_location
  shared_credentials_file = "./../../../../.aws/credentials"
}

# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
# @@@ Key Pair for machine Access @@@
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

resource "aws_key_pair" "key_pair" {
  key_name   = "AccessKey"
  public_key = file("~/.ssh/AccessKey.pub")
}

# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
# @@@ Create Virtual Priv Network @@@
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

module "vpc" {
  source  = "./../../tools/VPC"
  v4_cidr = "126.157.0.0/16"
  hostname = true

  # @@@ TAGS @@@
  name_tag = "${var.project}-Cloud"
  network_tag = "${var.project}"
}

module "igw" {
  source = "./../../tools/IGW"
  vpc_id = module.vpc.id

  # @@@ TAGS @@@
  name_tag    = "${var.project}-Network_Gate"
  network_tag = "${var.project}"
}

data "aws_availability_zones" "available" {
  state = "available"
}

module "subnet_public" {
  source  = "./../../tools/SUBNET"
  availability_zone = data.aws_availability_zones.available.names[0]
  v4_cidr = "126.157.10.0/24"
  pub_ip  = true
  vpc_id  = module.vpc.id

  # @@@ TAGS @@@
  name_tag    = "${var.project}-Subnet"
  network_tag = "${var.project}"
}

module "subnet_private" {
  source  = "./../../tools/SUBNET"
  availability_zone = data.aws_availability_zones.available.names[0]
  v4_cidr = "126.157.20.0/24"
  pub_ip  = true
  vpc_id  = module.vpc.id

  # @@@ TAGS @@@
  name_tag    = "${var.project}-Subnet"
  network_tag = "${var.project}"
}

module "public_routes" {
  source  = "./../../tools/ROUTES"
  vpc_id  = module.vpc.id
  v4_cidr = "0.0.0.0/0"
  igw_id  = module.igw.id

  # @@@ TAGS @@@
  name_tag    = "${var.project}-Routes"
  network_tag = "${var.project}"
}

module "public_routes_association" {
  source    = "./../../tools/ROUTES/ASSOCIATION"
  table_id  = module.public_routes.id
  subnet_id = module.subnet_public.id
}

# iam user

# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
# @@@@@@ Create Security Group @@@@@@
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

module "sg" {
  source         = "./../../tools/SG"
  sg_description = "This Security Group is created to allow various port access to an instance."
  vpc_id         = module.vpc.id
  port_desc      = {
    22 = "Open-SSH-Access"
    80 = "Open-HTTP-Access"
    1433 = "Open-SQL-Access"
    5000 = "Open-Python-Flask"
    8080 = "Open-Jenkins"
    }
  in_port        = [22, 80, 1433, 5000, 8080]
  in_cidr        = "0.0.0.0/0"
  out_port       = 0
  out_protocol   = "-1"
  in_protocol    = "tcp"
  out_cidr       = "0.0.0.0/0"

  # @@@ TAGS @@@
  name_tag = "${var.project}-port_access"
  network_tag = "${var.project}"
}

# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
# @@@@@@@ Create EC2 Instance @@@@@@@
# @@@@@@@       Manager       @@@@@@@
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

module "ec2_${var.project}" {
  source         = "./../../tools/EC2"
  instance_count = "1"
  ami_code       = "ami-08bac620dc84221eb" # Ubuntu 20.04
  type_code      = "t2.micro"            # 1 x CPU + 1 x RAM
  pem_key        = "AccessKey"
  subnet         = module.subnet_public.id
  vpc_sg         = [module.sg.id]
  pub_ip         = true
  lock           = var.locked
  user_data      = templatefile("./../../tools/boot_scripts/boot.sh", {})

  # @@@ TAGS @@@
  name_tag = "${var.project}-EC2"
  network_tag = "${var.project}"
}