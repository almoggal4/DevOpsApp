# add the elatsic public ip to the hosts file
kubernetes_server_public_ip=$(cat ./ec2_public_ip)
sudo echo "[kubernetes-servers]" > ./hosts
sudo echo 'master ansible_host='$kubernetes_server_public_ip 'ansible_connection=ssh ansible_ssh_private_key_file=/home/root/PrivateFiles/kubernetes-managment-key-pair-private.pem' >> ./hosts

# Check the syntax of the playbook
ansible-playbook playbook.yml --syntax-check

valid_syntax=$?

if [ $valid_syntax -eq 0 ]; then
    echo "Playbook syntax is valid."

    ansible-playbook playbook.yml -i ./hosts
    echo "Playbook Runned Succesfully, Kuberntes is now installed on the servers."
    fi
fi
echo "Playbook syntax is invalid"
