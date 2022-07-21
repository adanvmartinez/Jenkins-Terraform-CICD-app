module "eks" {
    source = "terraform-aws-modules/eks/aws"
    version = "~> 18.0"
    cluster_name = "terrafrom-lab-cluster"
    cluster_version = "1.22"
    subnet_ids = [aws_subnet.terraform-lab-subnet.id, aws_subnet.terraform-lab-subnet2.id]

    vpc_id = aws_vpc.terraform-lab-vpc.id

    eks_managed_node_groups ={
        desired_capacity = 3
        max_capacity = 3
        min_capacity = 3
    }
   
}

data "aws_eks_cluster" "cluster" {
    name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
    name = module.eks.cluster_id
}
