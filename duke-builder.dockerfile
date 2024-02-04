FROM debian:bookworm

# Install the debian live-build package
RUN apt-get update && apt-get install -y live-build
RUN mkdir /duke

WORKDIR /duke

# Install OpenSSH server
RUN apt-get update && apt-get install -y openssh-server
RUN mkdir /var/run/sshd
RUN echo 'root:root123' | chpasswd
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]