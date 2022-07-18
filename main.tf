

#Create VPC
resource "aws_vpc" "adan-terraform-vpc" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true
  instance_tenancy = "default"
  tags = {
    "Name" = "adan-terraform-vpc"
  }
  
}

# # #Create a public subnet
resource "aws_subnet" "terraform_public_subnet" {
  vpc_id = aws_vpc.adan-terraform-vpc.id
  cidr_block = var.public_subnet_cidr
  tags = {
    "Name" = "adan-terraform-public_subnet"
  }
  availability_zone = "us-west-1a"
}

# # Create Internet Gateway
resource "aws_internet_gateway" "terraform_IGW" {
  vpc_id = aws_vpc.adan-terraform-vpc.id #Use the ID from the vpc creted in the first step
  tags = {
    "Name" = "adan-terraform-IGW"
  }
  
}

# # #Create a public route table
resource "aws_route_table" "terraform_public_rt" {
  vpc_id = aws_vpc.adan-terraform-vpc.id
  route  {
    cidr_block="0.0.0.0/0"
    gateway_id=aws_internet_gateway.terraform_IGW.id 
    }
    tags = {
    "Name" = "adan-terraform-public-rt"
  }
}




# # #Associate route table with spublic subnet
resource "aws_route_table_association" "terraform_public_RT_association" {
  subnet_id = aws_subnet.terraform_public_subnet.id
  route_table_id = aws_route_table.terraform_public_rt.id
  
}

resource "aws_main_route_table_association" "terraform_main_RT_association" {
  vpc_id = aws_vpc.adan-terraform-vpc.id
  route_table_id = aws_route_table.terraform_public_rt.id
  
}



 resource "aws_security_group" "terraform_allow_ssh" {
  name = "allows ssh"
  description = "Allows SSH connections to terraform VPC"
  vpc_id = aws_vpc.adan-terraform-vpc.id
  ingress  {
    description = "Inbound rule"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  

  ingress {
    description      = "Inbound rule"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    description      = "Inbound rule"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_ssh"
  }
}



# resource "aws_route" "internet_route" {
#   route_table_id = aws_vpc.adan-terraform-vpc.default_route_table_id
#   destination_cidr_block = "0.0.0.0/0"
#   gateway_id = aws_internet_gateway.terraform_IGW.id
# }
# resource "aws_eip" "terraform_IP" {
#   vpc = true
# }

# # #Create a NAT Gateway
# # resource "aws_nat_gateway" "terraform_NAT_gateway" {
# #   allocation_id = aws_eip.terraform_IP.id
# #   subnet_id = aws_subnet.terraform_public_subnet.id
# #   tags = {
# #     "Name" = "adan-terraform-NAT-gateway"
# #   }
# # }

# #Crete ssh key
#resource "aws_key_pair" "ssh_key" {
  #key_name = "asus-key"
  #public_key = file("${var.ssh-key}")
#}









# #Create EC2 instance
resource "aws_instance" "terraform_instance" {
  ami = data.aws_ami.amazon-linux.id
  instance_type = "t2.micro"
  #key_name = aws_key_pair.ssh_key.id
  vpc_security_group_ids = [aws_security_group.terraform_allow_ssh.id]
  subnet_id = aws_subnet.terraform_public_subnet.id
  associate_public_ip_address = true
  availability_zone = "us-west-1a"
  tags={
    "Name"="terraform-instance"
  }
}

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "17.24.0"
  cluster_name    = "Jenkins-cluster"
  cluster_version = "1.22"
  subnets         = [aws_subnet.terraform_public_subnet.id]

  vpc_id = module.vpc.vpc_id

  node_groups = {
      desired_capacity = 3
      max_capacity     = 3
      min_capacity     = 3
  }  
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}
