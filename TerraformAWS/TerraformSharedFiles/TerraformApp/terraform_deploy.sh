#!/bin/bash

terraform init
validate_output=$(terraform validate)

# Define the expected value
expected_value="Success!"
# Check if terraform configuration is valid
if [[ "$validate_output" == *"$expected_value"* ]]; then
    # apply the validate configuration
    sudo terraform apply -auto-approve
    # refreshing the new state
    terraform refresh
    # save the public ip of the ec2 for later use
    terraform_output_ip=$(terraform output)
    ec2_created_public_ip="$(cut -d' ' -f3 <<<"$terraform_output_ip")"
    echo "$ec2_created_public_ip" | sed s/'"'//g
else
    echo "Terraform validate has failed, check the configuration of the terraform files."
    exit 1
fi