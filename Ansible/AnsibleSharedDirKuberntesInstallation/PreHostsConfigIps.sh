# /bin/bash
# create an host file dynamiclly based on the ip given by aws
instance_ip=`aws ec2 describe-addresses --filters "Name=tag:kubernetes.io/cluster/kubernetes,Values=owned" | grep '"PublicIp":' | awk -F : '{print $2}' | tr -d '" ,'`
printf '%s\n' 'kubernetes-servers:'\
    "  hosts:" \
    "    master:"\
    "      ansible_host: $instance_ip" \
    "      ansible_connection: ssh"\
    "      ansible_ssh_private_key_file: ../PrivateFiles/kubernetes-managment-key-pair-private.pem" >./hosts