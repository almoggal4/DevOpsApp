FROM ubuntu:latest
USER root
RUN apt-get -y update;
RUN apt-get install -y python3 python3-pip vim openssh-client openssh-server sudo
RUN python3 -m pip install ansible
RUN export PATH=$PATH:~/.local/bin
# prepare for ssh connection
RUN useradd jenkins-remote-user
RUN mkdir /home/jenkins-remote-user/; exit 0 && \
    mkdir /home/jenkins-remote-user/.ssh; exit 0 && \
    chmod 700 /home/jenkins-remote-user/.ssh && \
    chown -R jenkins-remote-user:jenkins-remote-user /home/jenkins-remote-user
COPY AnsibleSharedFiles/JenkinsPublicKey/jenkinspublickey.pub /home/jenkins-remote-user/.ssh/authorized_keys
RUN chown jenkins-remote-user:jenkins-remote-user -R /home/jenkins-remote-user/.ssh && \
    chmod 600 /home/jenkins-remote-user/.ssh/authorized_keys
RUN echo "jenkins-remote-user   ALL = NOPASSWD: ALL" >> /etc/sudoers
ENTRYPOINT service ssh restart && bash