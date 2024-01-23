FROM ubuntu:20.04
USER root
RUN apt-get -y update;
RUN apt-get install -y python3 python3-pip vim openssh-client
RUN python3 -m pip install --user ansible
RUN export PATH=$PATH:~/.local/bin