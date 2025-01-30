# Use a lightweight base image
FROM ubuntu:24.04

# Install SSH server
RUN apt-get update && apt-get install -y openssh-server && \
    apt-get install -y python3-apt && \
    apt-get install -y systemd sudo && \
    mkdir /var/run/sshd && \
    apt-get clean

# Allow root login with key-based authentication only
RUN sed -i 's/^#PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/^#PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    mkdir -p /root/.ssh && chmod 700 /root/.ssh

# Create localadmin user
RUN useradd -m -s /bin/bash localadmin && \
    echo 'localadmin:password' | chpasswd && \
    usermod -aG sudo localadmin && \
    mkdir /home/localadmin/.ssh && \
    chown localadmin:localadmin -R  /home/localadmin/ && \
    chmod 700 /home/prod_user/.ssh

RUN echo 'localadmin ALL=(ALL) ALL' >> /etc/sudoers

# Expose SSH port
EXPOSE 22

# Start SSH server
CMD ["/usr/sbin/sshd", "-D"]

