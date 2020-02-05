FROM ubuntu:xenial

# install packages
RUN set -eux; \
	apt-get update; \
	apt-get install -y gosu sudo locales make less git curl libapr1 unzip uuid-runtime jq bsdmainutils python docker.io wget software-properties-common apt-transport-https; \
	rm -rf /var/lib/apt/lists/*;

# Install Adopt JDK11
RUN wget -qO - https://adoptopenjdk.jfrog.io/adoptopenjdk/api/gpg/key/public | apt-key add - ; \
    add-apt-repository --yes https://adoptopenjdk.jfrog.io/adoptopenjdk/deb/ ; \
    apt update ; apt install -y adoptopenjdk-11-hotspot



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


# Add java to PATH for all users, and user
RUN echo "PATH=/usr/lib/jvm/java-11-openjdk-amd64/bin:$PATH" >> /etc/environment
RUN echo "JAVA_HOME_8_X64=/usr/lib/jvm/java-11-openjdk-amd64" >> /etc/environment
RUN echo "JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64" >> /etc/environment

ENV JAVA_HOME_11_X64 "/usr/local/openjdk-11"
#ENV MAVEN_CONFIG "/home/user/.m2"


# Use UTF-8
RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen ; locale-gen ; update-locale en_US.UTF-8
ENV LC_ALL "en_US.UTF-8"
ENV LANG "en_US.UTF-8"
ENV LANGUAGE "en_US.UTF-8"

#WORKDIR /home/user/flink
