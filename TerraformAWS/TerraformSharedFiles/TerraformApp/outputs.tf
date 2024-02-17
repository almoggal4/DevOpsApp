output "ec2_global_kubernetes_ips" {
  value = aws_instance.kubernetes-cluster-ec2.public_ip
}