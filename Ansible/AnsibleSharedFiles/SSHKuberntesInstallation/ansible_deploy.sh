#ansible-playbook playbook.yml -i ./hosts
kubernetes_server_public_ip=$(cat ./ec2_public_ip)
echo "[kubernetes-servers]" > ./hosts
echo 'master ansible_host='$kubernetes_server_public_ip 'ansible_connection=ssh ansible_ssh_private_key_file=/home/root/PrivateFiles/kubernetes-managment-key-pair-private.pem' >> ./hosts
# get the ip externally - not hard coded
# check that the ansible playbook is valid - validate
# run the playbook 