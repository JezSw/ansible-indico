# Use a lightweight base image
FROM rockylinux:9

# Install SSH server
RUN dnf -y update && dnf -y install openssh-server python3-dnf systemd sudo && \
    mkdir /var/run/sshd && \
    dnf clean dbcache

# Allow root login with key-based authentication only
RUN sed -i 's/^#PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/^#PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    mkdir -p /root/.ssh && chmod 700 /root/.ssh

# Create localadmin user
RUN useradd -m -s /bin/bash localadmin && \
    echo 'localadmin:password' | chpasswd && \
    usermod -aG wheel localadmin && \
    mkdir /home/localadmin/.ssh && \
    chown localadmin:localadmin -R  /home/localadmin/ && \
    chmod 700 /home/prod_user/.ssh

RUN echo 'localadmin ALL=(ALL) ALL' >> /etc/sudoers

RUN systemctl enable sshd.service
COPY molecule/default/templates/rockylinux9/init_script.sh /etc/init.d/

# Expose SSH port
EXPOSE 22

# Start SSH server
CMD ["/usr/sbin/init"]
