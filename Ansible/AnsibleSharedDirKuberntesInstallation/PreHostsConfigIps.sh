# /bin/bash
# create an host file dynamiclly based on the ip given by aws ang giving the key file the write permissions
private_file_path=../PrivateFiles/kubernetes-managment-key-pair-private.pem
instance_ip=`aws ec2 describe-addresses --filters "Name=tag:kubernetes.io/cluster/kubernetes,Values=owned" | grep '"PublicIp":' | awk -F : '{print $2}' | tr -d '" ,'`
printf '%s\n' 'kubernetes-servers:'\
    "  hosts:" \
    "    master:"\
    "      ansible_host: $instance_ip" \
    "      ansible_connection: ssh"\
    "      ansible_ssh_private_key_file: $private_file_path" >./hosts
chmod 700 $private_file_path