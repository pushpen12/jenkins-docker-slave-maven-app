FROM ubuntu:18.04

# main credit of the  code goes to Bibin Wilson, I (Sayantan) customized some parts
# LABEL maintainer="Bibin Wilson <bibinwilsonn@gmail.com>"
LABEL maintainer="Sayantan Samanta <sayantansamanta098@gmail.com>"

# Make sure the package repository is up to date.
RUN apt-get update && \
    apt-get -qy full-upgrade && \
    apt-get install -qy git && \
# Install a basic SSH server
    apt-get install -qy openssh-server && \
    mkdir -p /var/run/sshd && \
# Install JDK 11
    apt-get install -qy openjdk-11-jdk && \
# Install maven
    apt-get install -qy maven && \
# Cleanup old packages
    apt-get -qy autoremove && \
# Add user jenkins to the image
    adduser --quiet jenkins && \
# Set password for the jenkins user (you may want to alter this).
    echo "jenkins:jenkins" | chpasswd && \
    mkdir /home/jenkins/.m2
RUN chown -R jenkins:jenkins /home/jenkins/.m2/

# Copy authorized keys
# COPY .ssh/authorized_keys /home/jenkins/.ssh/authorized_keys

# RUN chown -R jenkins:jenkins /home/jenkins/.m2/ && \
#    chown -R jenkins:jenkins /home/jenkins/.ssh/

# Disable public key-based authentication
RUN sed -i '/^#PubkeyAuthentication/s/^#//' /etc/ssh/sshd_config && \
    sed -i 's/^PubkeyAuthentication yes/PubkeyAuthentication no/' /etc/ssh/sshd_config

# Enable password authentication
RUN sed -i 's/^#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Standard SSH port
EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]

