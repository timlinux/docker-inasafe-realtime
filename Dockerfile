#--------- Generic stuff all our Dockerfiles should start with so we get caching ------------
FROM ubuntu:14.04
MAINTAINER Akbar Gumbira <akbargumbira@gmail.com>

RUN export DEBIAN_FRONTEND=noninteractive
ENV DEBIAN_FRONTEND noninteractive
RUN dpkg-divert --local --rename --add /sbin/initctl

# Use local cached debs from host (saves your bandwidth!)
# Change ip below to that of your apt-cacher-ng host
# Or comment this line out if you do not wish to use caching
ADD 71-apt-cacher-ng /etc/apt/apt.conf.d/71-apt-cacher-ng

RUN echo "deb http://archive.ubuntu.com/ubuntu trusty main universe" > /etc/apt/sources.list
RUN apt-get -y update
# socat can be used to proxy an external port and make it look like it is local
RUN apt-get -y install ca-certificates openssh-server supervisor rpl pwgen
RUN mkdir /var/run/sshd
ADD sshd.conf /etc/supervisor/conf.d/sshd.conf

# Ubuntu 14.04 by default only allows non pwd based root login
# We disable that but also create an .ssh dir so you can copy
# up your key. NOTE: This is not a particularly robust setup
# security wise and we recommend to NOT expose ssh as a public
# service.
RUN rpl "PermitRootLogin without-password" "PermitRootLogin yes" /etc/ssh/sshd_config
RUN mkdir /root/.ssh
RUN chmod o-rwx /root/.ssh

#-------------Application Specific Stuff ----------------------------------------------------
# Open port 22 so linked containers can see it
EXPOSE 22

# Install QGIS 2.4, git, and paramiko
RUN echo "deb http://qgis.org/debian trusty main" >> /etc/apt/sources.list; echo "deb-src http://qgis.org/debian trusty main" >> /etc/apt/sources.list
RUN gpg --keyserver keyserver.ubuntu.com --recv 47765B75; gpg --export --armor 47765B75 | sudo apt-key add -
RUN apt-get -y update
RUN apt-get -y install qgis python-qgis git python-paramiko

# Get InaSAFE 2.1
# For production use this:
RUN git clone --branch master git://github.com/AIFDR/inasafe.git --depth 1 /home/realtime/src/inasafe
# TODO: For development, copy from host. Not finished
# ADD version-2_1_0.tar.gz /tmp/inasafe.tar.gz
# RUN tar xfz /tmp/inasafe.tar.gz

# Copy realtime env variables
ADD run-env-linux.sh /home/realtime/src/inasafe/run-env-linux.sh

# Run any additional tasks here that are too tedious to put in
# this dockerfile directly.
ADD setup.sh /setup.sh
RUN chmod 0755 /setup.sh
RUN /setup.sh

# Called on first run of docker - will run supervisor
ADD start.sh /start.sh
RUN chmod 0755 /start.sh

CMD /start.sh
