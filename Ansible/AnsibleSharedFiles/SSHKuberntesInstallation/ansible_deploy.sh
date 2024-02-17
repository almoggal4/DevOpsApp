#ansible-playbook playbook.yml -i ./hosts
echo "[kubernetes-servers]" > ./hosts
echo "master ansible_host=3.74.189.204 ansible_connection=ssh ansible_ssh_private_key_file=/home/root/PrivateFiles/kubernetes-managment-key-pair-private.pem" >> ./hosts
# get the ip externally - not hard coded
# check that the ansible playbook is valid - validate
# run the playbook 