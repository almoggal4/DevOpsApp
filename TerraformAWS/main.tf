# resource object attributes provide simply.
# provider "aws" {
#   region = "eu-central-1"
#   access_key = "AKIA25NELYLWBVRQA5ME"
#   secret_key = "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"
# }

# create a vpc for the k8s cluster
resource "aws_vpc" "kubernetes-vpc" {
 cidr_block = var.kubernetesVpcCidr
 tags = var.AwsProjectTags
}

# create a public subnet in the k8s vpc
resource "aws_subnet" "kubernetes-vpc-public-subnet" {
  vpc_id = aws_vpc.kubernetes-vpc.id
  cidr_block = var.kubernetesVpcSubnetPublicCidr
  tags = var.AwsProjectTags
}

# create an internet gateway for the public subnet in the k8s vpc
resource "aws_internet_gateway" "kubernetes-vpc-internet-gateway" {
  vpc_id = aws_vpc.kubernetes-vpc.id
  tags = var.AwsProjectTags
}

# create a route table for the public subnets that enables them to accsess the public internet.
resource "aws_route_table" "kubernetes-vpc-route-table" {
  vpc_id = aws_vpc.kubernetes-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.kubernetes-vpc-internet-gateway.id
  }
  tags = var.AwsProjectTags
}

# associate the public subnets with the route table
resource "aws_route_table_association" "kubernetes-vpc-route-table-associate-to-public-subnets" {
  subnet_id = aws_subnet.kubernetes-vpc-public-subnet.id
  route_table_id = aws_route_table.kubernetes-vpc-route-table.id
}

# resource "aws_network_interface" "kubernetes-ec2-network-interface" {
#   subnet_id = aws_subnet.kubernetes-vpc-public-subnet[0].id
#   #private_ip = "10.0.1.1"
#   tags = var.AwsProjectTags
# }

# create a security group for the k8s cluster ec2 instances.
resource "aws_security_group" "kubernetes-cluster-security-group" {
  name = "kubernetes-cluster-security-group"
  description = "Allow the Kuberntes cluster to communicate internally and to be managed externally"
  vpc_id = aws_vpc.kubernetes-vpc.id
  tags = var.AwsProjectTags
}

# 
# security group outbound rule that allows all traffic from the internal vpc cidr
resource "aws_vpc_security_group_ingress_rule" "InboundSecurityGroupAllowAllPrivateTraffic" {
  security_group_id = aws_security_group.kubernetes-cluster-security-group.id
  cidr_ipv4         = aws_vpc.kubernetes-vpc.cidr_block
  ip_protocol       = "-1" # semantically equivalent to all ports
}

# security group inbound rule that allows all traffic from the managment ips
resource "aws_vpc_security_group_ingress_rule" "InboundSecurityGroupAllowAllPublicTraffic" {
  security_group_id = aws_security_group.kubernetes-cluster-security-group.id
  count = length(var.KubernetesAdminsManagmentIpsCidr)
  cidr_ipv4         = element(var.KubernetesAdminsManagmentIpsCidr, count.index)
  ip_protocol       = "-1" # semantically equivalent to all ports
}

# security group outbound rule that allows the k8s cluster instances to communicate with the public internet
resource "aws_vpc_security_group_egress_rule" "OutboundSecurityGroupAllowAllPublicTraffic" {
  security_group_id = aws_security_group.kubernetes-cluster-security-group.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

# create iam policy for master node
resource "aws_iam_policy" "kubernetes-master-node-policy1" {
  name = "kubernetes-master-node-policy1"
  policy = file("${path.module}/kubernetes-master-node-policy1.json")
  tags = var.AwsProjectTags
}

# create iam policy for worker node
resource "aws_iam_policy" "kubernetes-worker-node-policy1" {
  name = "kubernetes-worker-node-policy1"
  policy = file("${path.module}/kubernetes-worker-node-policy1.json")
  tags = var.AwsProjectTags
}

# create iam role for k8s master node/cluster node
resource "aws_iam_role" "kubernetes-master-node-role1" {
  name = "kubernetes-master-node-role1"
  assume_role_policy = file("${path.module}/kubernetes-master-node-role1-trust-policy.json")
  tags = var.AwsProjectTags
}

# attach the iam policies to the iam role
resource "aws_iam_policy_attachment" "kubernetes-master-node-role-policy-attachment-master-policy" {
  name = "kubernetes-master-node-role-policy-attachment-master-policy"
  policy_arn = aws_iam_policy.kubernetes-master-node-policy1.arn
  roles = [aws_iam_role.kubernetes-master-node-role1.name]
}

# attach the iam policies to the iam role
resource "aws_iam_policy_attachment" "kubernetes-master-node-role-policy-attachment-worker-policy" {
  name = "kubernetes-master-node-role-policy-attachment-worker-policy"
  policy_arn = aws_iam_policy.kubernetes-worker-node-policy1.arn
  roles = [aws_iam_role.kubernetes-master-node-role1.name]
}

# create an IAM instance profile
resource "aws_iam_instance_profile" "kubernetes-cluster-ec2-instance-profile" {
  name = "kubernetes-cluster-ec2-instance-profile"
  role = aws_iam_role.kubernetes-master-node-role1.name
}

# create a key pair to connect and manage the ec2
# choose the encryption type RSA
resource "tls_private_key" "kubernetes-managment-key-pair" {
 algorithm = "RSA"
}

# create a key pair and generate public key based on RSA encryption
resource "aws_key_pair" "kubernets-ec2-key-pair" {
 key_name = var.KubernetesEc2Setting["key_pair_name"]
 public_key = "${tls_private_key.kubernetes-managment-key-pair.public_key_openssh}"
 depends_on = [
  tls_private_key.kubernetes-managment-key-pair
 ]
}

# create the private key file based on the key pair and the RSA encryption.
# creates 2 versions of files: pem (the old private key file) and ppk (the new prvate key file - for putty i.e)
resource "local_file" "kubernetes-ec2-generated-public-key-file" {
 content = "${tls_private_key.kubernetes-managment-key-pair.private_key_pem}"
 filename = "${var.KubernetesEc2Setting["key_pair_name"]}-private.pem"
 file_permission ="0400"
 depends_on = [
  tls_private_key.kubernetes-managment-key-pair
 ]
 # convert the pem to ppk when the resource is created
 provisioner "local-exec" {
    when = create
    on_failure = continue
    command = "winscp.com /keygen ${var.KubernetesEc2Setting["key_pair_name"]}-private.pem /output=${var.KubernetesEc2Setting["key_pair_name"]}-private.ppk"
 }
 # delete the ppk file when the resource is deleted
 provisioner "local-exec" {
   when = destroy
   on_failure = fail
   command = "del /S *.ppk"
 }

}

# create ec2 instance to run the k8s cluster
resource "aws_instance" "kubernetes-cluster-ec2" {
  ami = var.KubernetesEc2Setting["ami"] # OS
  instance_type = var.KubernetesEc2Setting["instance_type"] # type (size)
  iam_instance_profile = aws_iam_instance_profile.kubernetes-cluster-ec2-instance-profile.name # iam role (iam policies)
  vpc_security_group_ids = [aws_security_group.kubernetes-cluster-security-group.id] # security group (inbound & outbound rules)
  subnet_id = aws_subnet.kubernetes-vpc-public-subnet.id # choose the subnet (and the vpc)
  key_name = "${aws_key_pair.kubernets-ec2-key-pair.key_name}" # pre generated key pair
  tags = var.AwsProjectTags # tags
}

resource "aws_eip" "kubernetes-cluster-ec2-elastic-ip" {
  instance = aws_instance.kubernetes-cluster-ec2.id
  domain = "vpc"
}