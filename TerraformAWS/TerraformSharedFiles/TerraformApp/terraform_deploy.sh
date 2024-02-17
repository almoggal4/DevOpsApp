#!/bin/bash
#terraform init
# Run your command and capture its output
validate_output=$(terraform validate)

# Define the expected value
expected_value="Success!"

echo "$validate_output"
# Check if terraform configuration is valid
if [[ "$validate_output" == *"$expected_value"* ]]; then
    #sudo terraform apply -auto-approve
    # save the public ip of the ec2 for later use
    terraform output
    #terraform_output_ip=$(terraform output)
    #ec2_created_public_ip="$(cut -d' ' -f3 <<<"$terraform_output_ip")"
    #echo "$ec2_created_public_ip" | sed s/'"'//
else
    echo "Terraform validate has failed, check the configuration of the terraform files."
    exit 1
fi