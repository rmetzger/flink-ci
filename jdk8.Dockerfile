FROM ubuntu:xenial

# install packages
RUN set -eux; \
	apt-get update; \
	apt-get install -y gosu sudo locales make less git openjdk-8-jdk curl libapr1 unzip uuid-runtime python docker.io; \
	rm -rf /var/lib/apt/lists/*;

# Install maven
ARG MAVEN_VERSION=3.2.5
ARG USER_HOME_DIR="/root"
ARG BASE_URL=https://apache.osuosl.org/maven/maven-3/${MAVEN_VERSION}/binaries

RUN mkdir -p /usr/share/maven /usr/share/maven/ref \
  && curl -fsSL -o /tmp/apache-maven.tar.gz ${BASE_URL}/apache-maven-${MAVEN_VERSION}-bin.tar.gz \
  && tar -xzf /tmp/apache-maven.tar.gz -C /usr/share/maven --strip-components=1 \
  && rm -f /tmp/apache-maven.tar.gz \
  && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

ENV MAVEN_HOME /usr/share/maven


# make is required for flink-python tests

# add libssl1.0.0 for SSL tests in flink-runtime
#RUN wget http://security.debian.org/debian-security/pool/updates/main/o/openssl/libssl1.0.0_1.0.1t-1+deb8u12_amd64.deb; \
# dpkg -i libssl1.0.0_1.0.1t-1+deb8u12_amd64.deb ; \
# rm libssl1.0.0_1.0.1t-1+deb8u12_amd64.deb

# add user to execute Flink tests (they can't execute as root)
#RUN useradd -ms /bin/bash user
#RUN echo "user ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Add java to PATH for all users, and user
RUN echo "PATH=/usr/lib/jvm/java-8-openjdk-amd64/bin:$PATH" >> /etc/environment
RUN echo "JAVA_HOME_8_X64=/usr/lib/jvm/java-8-openjdk-amd64" >> /etc/environment
RUN echo "JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64" >> /etc/environment
#RUN echo "export PATH=/usr/local/openjdk-8/bin:$PATH" >> /home/user/.bashrc

ENV JAVA_HOME_8_X64 "/usr/lib/jvm/java-8-openjdk-amd64"
ENV JAVA_HOME "/usr/lib/jvm/java-8-openjdk-amd64"
#ENV MAVEN_CONFIG "/home/user/.m2"

## make the "mvn" command use gosu for running as 'user' by default
## The Flink tests require non-root permissions for some file permissions tests
## use sudo -E to preserve environment
#RUN mv /usr/share/maven/bin/mvn /usr/share/maven/bin/vanilla-mvn
#RUN printf '#!/bin/sh\n\
#sudo -E gosu vsts_azpcontainer /usr/share/maven/bin/vanilla-mvn $@'\
#>> /usr/share/maven/bin/mvn

#RUN chmod +x /usr/share/maven/bin/mvn

# Use UTF-8
RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen ; locale-gen ; update-locale en_US.UTF-8
ENV LC_ALL "en_US.UTF-8"
ENV LANG "en_US.UTF-8"
ENV LANGUAGE "en_US.UTF-8"

#WORKDIR /home/user/flink
