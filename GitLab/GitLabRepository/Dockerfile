FROM ubuntu:latest
USER root
WORKDIR /root
RUN apt update
RUN apt install -y git
RUN git clone http://localhost:9090/gitlabgroup/gitlabrepository.git; exit 0
