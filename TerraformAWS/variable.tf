variable "AwsProjectTags" {
  type = map(string)
  default = {
    "kubernetes.io/cluster/kubernetes" = "owned"
  }
  description = "Tags to project."
}

variable "kubernetesVpcCidr" {
  type = string
  default = "10.0.0.0/16"
  description = "The CIDR of the K8S cluster VPC."
}

variable "kubernetesVpcSubnetPublicCidr" {
  type = string
  default = "10.0.1.0/24"
  description = "The public subnets of the K8s cluster VPC."
}

variable "KubernetesAdminsManagmentIpsCidr" {
  type = list(string)
  default = []
  description = "The public IP's CIDRs that will manges the kubernetes cluster."
}

variable "KubernetesEc2Setting" {
  type = map(string)
  default = {
    "ami" = "ami-0faab6bdbac9486fb"
    "instance_type" = "t3.medium"
    "key_pair_name" = "kubernetes-managment-key-pair"
  }
  description = "The setup configuration for the ec2 K8s instance."
}

variable "PrivateFilesLocation" {
  type = string
  default = "../../PrivateFiles/"
  description = "The path to the private folder for secret files."
}

variable "PreCreatedElasticIPAllocationId" {
  type = string
  default = "eipalloc-0525d74cfd39791cb"
  description = "The pre-created elatsic ip's allocation id."
}