# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

# eks 
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "17.20.0"

  cluster_version = "1.21"
  cluster_name    = "graviton2-hackathon"
  vpc_id          = module.vpc.vpc_id
  subnets         = module.vpc.private_subnets

  node_groups = {
    arm = {
      ami_type  = "AL2_ARM_64"

      desired_capacity = 1
      max_capacity     = 1
      min_capacity     = 1

      instance_types = ["t4g.small"]
      capacity_type  = "SPOT"
      k8s_labels = {
        Environment = "test"

      }
    }
    x86 = {
      ami_type  = "AL2_x86_64"

      desired_capacity = 1
      max_capacity     = 1
      min_capacity     = 1

      instance_types = ["t3.small"]
      capacity_type  = "SPOT"
      k8s_labels = {
        Environment = "test"
        
      }
    }    
  }
}

data "aws_eks_cluster" "eks" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "eks" {
  name = module.eks.cluster_id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.eks.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.eks.token
}
