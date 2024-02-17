FROM jenkins/jenkins:2.426.1-jdk17
USER root
RUN apt-get update && apt-get install -y lsb-release sshpass vim
RUN curl -fsSLo /usr/share/keyrings/docker-archive-keyring.asc \
  https://download.docker.com/linux/debian/gpg
RUN echo "deb [arch=$(dpkg --print-architecture) \
  signed-by=/usr/share/keyrings/docker-archive-keyring.asc] \
  https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list
# downloading docker
RUN apt-get update && apt-get install -y docker-ce-cli
RUN apt-get install -y docker-ce containerd.io docker-buildx-plugin docker-compose-plugin
RUN mkdir /var/jenkins_home/SharedFiles
RUN jenkins-plugin-cli --plugins "blueocean docker-workflow"
WORKDIR /root
# configuring ssh settings to all relevent servers + start docker daemon
RUN echo 'ssh-keygen -f /root/.ssh/id_rsa -P ""' >> /usr/local/bin/jenkins.sh
#CMD ssh-keygen -f /root/.ssh/id_rsa -P ""