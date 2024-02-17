#!/bin/bash
#terraform init
# Run your command and capture its output
validate_output=$(terraform validate)

# Define the expected value
expected_value="Success!"

echo "$validate_output"
# Check if the output equals the expected value
if [[ "$validate_output" == *"$expected_value"* ]]; then
    sudo terraform apply -auto-approve
else
    echo "Terraform validate has failed, check the configuration of the terraform files."
    exit 1
fi