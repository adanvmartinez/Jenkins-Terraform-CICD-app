







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





# # #Create EC2 instance
# resource "aws_instance" "terraform_instance" {
#   ami = data.aws_ami.amazon-linux.id
#   instance_type = "t2.micro"
#   key_name = aws_key_pair.ssh_key.id
#   vpc_security_group_ids = [aws_security_group.terraform_allow_ssh.id]
#   subnet_id = aws_subnet.terraform_public_subnet.id
#   associate_public_ip_address = true
#   availability_zone = "us-west-1a"
#   tags={
#     "Name"="terraform-instance"
#   }
# }
