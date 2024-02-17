#ansible-playbook playbook.yml -i ./hosts
kubernetes_server_public_ip=$1
sudo echo "[kubernetes-servers]" > ./hosts
sudo echo 'master ansible_host='$kubernetes_server_public_ip 'ansible_connection=ssh ansible_ssh_private_key_file=/home/root/PrivateFiles/kubernetes-managment-key-pair-private.pem' >> ./hosts
# check that the ansible playbook is valid - validate
# run the playbook 