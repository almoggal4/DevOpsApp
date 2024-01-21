FROM ubuntu:20.04
USER root
RUN apt-get -y update;
RUN apt-get install -y python3 python3-pip vim openssh-client unzip curl
RUN python3 -m pip install --user ansible
RUN export PATH=$PATH:~/.local/bin
RUN mkdir /etc/AWSCLIInstallation
WORKDIR /etc/AWSCLIInstallation
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
RUN unzip awscliv2.zip
RUN ./aws/install --bin-dir /usr/local/bin --install-dir /usr/local/aws-cli --update