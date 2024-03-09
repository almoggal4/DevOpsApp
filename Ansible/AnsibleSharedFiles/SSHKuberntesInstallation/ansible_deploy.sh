# add the elatsic public ip to the hosts file
kubernetes_server_public_ip=$(cat ./ec2_public_ip)
sudo echo "[kubernetes-servers]" > ./hosts
sudo echo 'master ansible_host='$kubernetes_server_public_ip 'ansible_connection=ssh ansible_ssh_private_key_file=/home/root/PrivateFiles/kubernetes-managment-key-pair-private.pem' >> ./hosts

# Check the syntax of the playbook
ansible-playbook ./playbook.yml --syntax-check

valid_syntax=$?

if [ $valid_syntax -eq 0 ]; then
    echo "Playbook syntax is valid."

    # Run the playbook in check mode
    ansible-playbook playbook.yml --check
    valid_playbook=$?

    if [ $valid_playbook -eq 0 ]; then
        echo "Playbook is valid and can be executed."
        # run the ansible playbook to install k8s on the ec2 (using the udated host file)
        ansible-playbook playbook.yml -i ./hosts
    else
        echo "Playbook contains errors."
    fi
fi
echo "Playbook is invalid"
