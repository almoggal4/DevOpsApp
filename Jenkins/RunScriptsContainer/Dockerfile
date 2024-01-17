FROM centos
RUN cd /etc/yum.repos.d/
RUN sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-*
RUN sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*
RUN yum -y install openssh-server passwd
RUN useradd remote-user
RUN echo "1234" | passwd remote-user --stdin && \
    mkdir /home/remote-user/.ssh && \
    chmod 700 /home/remote-user/.ssh 
COPY ./remote-key.pub /home/remote-user/.ssh/authorized_keys
RUN chown remote-user:remote-user -R /home/remote-user/.ssh/ && \
    chmod 600 /home/remote-user/.ssh/authorized_keys
RUN ssh-keygen -A
RUN rm /run/nologin
CMD /usr/sbin/sshd -D

# docker build -t remote-host .
# docker container run --name remote-host --restart=on-failure --network jenkins remote-host