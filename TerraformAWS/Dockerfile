FROM ubuntu:latest
USER root
# download terraform
RUN mkdir /Terraform; exit 0
RUN mkdir /Terraform/TerraformInstallation; exit 0
WORKDIR /Terraform/TerraformInstallation
RUN apt-get -y update && apt-get install -y unzip wget curl less putty-tools openssh-server sudo
RUN wget https://releases.hashicorp.com/terraform/1.0.7/terraform_1.0.7_linux_amd64.zip
RUN unzip terraform_1.0.7_linux_amd64.zip
RUN mv terraform /usr/local/bin/
# download awscli + configure
RUN mkdir /Terraform/AWSCLIInstallation; exit 0
WORKDIR /Terraform/AWSCLIInstallation
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
RUN unzip awscliv2.zip
RUN ./aws/install
RUN mkdir /root/.aws
# prepare for ssh connection
RUN useradd jenkins-remote-user
RUN mkdir /home/jenkins-remote-user/; exit 0 && \
    mkdir /home/jenkins-remote-user/.ssh; exit 0 && \
    chmod 700 /home/jenkins-remote-user/.ssh
COPY TerraformSharedFiles/JenkinsPublicKey/jenkinspublickey.pub /home/jenkins-remote-user/.ssh/authorized_keys
RUN chown jenkins-remote-user:jenkins-remote-user -R /home/jenkins-remote-user/.ssh && \
    chmod 600 /home/jenkins-remote-user/.ssh/authorized_keys
RUN echo "jenkins-remote-user   ALL = NOPASSWD: ALL" >> /etc/sudoers
# create the project directory
USER root
RUN mkdir /Terraform/PrivateFiles
RUN mkdir /Terraform/TerraformAWSInfrastructure/; exit 0
WORKDIR /Terraform/TerraformAWSInfrastructure/
ENTRYPOINT service ssh restart && bash

