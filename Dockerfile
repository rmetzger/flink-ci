FROM ubuntu:xenial

# install packages
RUN set -eux; \
	apt-get update; apt-get upgrade -y ; \
	apt-get install -y gosu sudo locales make less git build-essential openjdk-8-jdk curl libapr1 unzip uuid-runtime jq bsdmainutils wget python docker.io psmisc software-properties-common apt-transport-https; \
	rm -rf /var/lib/apt/lists/*;

# Install Adopt JDK11
RUN wget -qO - https://adoptopenjdk.jfrog.io/adoptopenjdk/api/gpg/key/public | apt-key add - ; \
    add-apt-repository --yes https://adoptopenjdk.jfrog.io/adoptopenjdk/deb/ ; \
    apt-get update ; apt-get install -y adoptopenjdk-11-hotspot

# Add java to PATH for all users, and user
# use java8 by default, but provide java11 as well
RUN echo "PATH=/usr/lib/jvm/java-8-openjdk-amd64/bin:$PATH" >> /etc/environment
RUN echo "JAVA_HOME_8_X64=/usr/lib/jvm/java-8-openjdk-amd64" >> /etc/environment
RUN echo "JAVA_HOME_11_X64=/usr/lib/jvm/adoptopenjdk-11-hotspot-amd64" >> /etc/environment
RUN echo "JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64" >> /etc/environment
RUN update-alternatives --set java /usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java
RUN update-alternatives --set javac /usr/lib/jvm/java-8-openjdk-amd64/bin/javac
RUN update-alternatives --set jps /usr/lib/jvm/java-8-openjdk-amd64/bin/jps
RUN update-alternatives --set jstack /usr/lib/jvm/java-8-openjdk-amd64/bin/jstack

ENV JAVA_HOME_8_X64 "/usr/lib/jvm/java-8-openjdk-amd64"
ENV JAVA_HOME_11_X64 "/usr/lib/jvm/adoptopenjdk-11-hotspot-amd64"
ENV JAVA_HOME "/usr/lib/jvm/java-8-openjdk-amd64"

# Install maven
ARG MAVEN_VERSION=3.2.5
ARG USER_HOME_DIR="/root"
ARG BASE_URL=https://apache.osuosl.org/maven/maven-3/${MAVEN_VERSION}/binaries

RUN mkdir -p /usr/share/maven /usr/share/maven/ref \
  && curl -fsSL -o /tmp/apache-maven.tar.gz ${BASE_URL}/apache-maven-${MAVEN_VERSION}-bin.tar.gz \
  && tar -xzf /tmp/apache-maven.tar.gz -C /usr/share/maven --strip-components=1 \
  && rm -f /tmp/apache-maven.tar.gz \
  && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

# put custom http-wagon. More details: https://issues.apache.org/jira/browse/FLINK-16947?focusedCommentId=17285028&page=com.atlassian.jira.plugin.system.issuetabpanels%3Acomment-tabpanel#comment-17285028
RUN cd /usr/share/maven/lib/ \
  && rm wagon-http-*-shaded.jar \
  && curl -O https://repo1.maven.org/maven2/org/apache/maven/wagon/wagon-http/3.4.3/wagon-http-3.4.3-shaded.jar

# add commons logging (needed for custom wagon)
RUN cd /tmp \
  && wget https://mirror.synyx.de/apache//commons/logging/binaries/commons-logging-1.2-bin.zip \
  && unzip commons-logging-1.2-bin.zip \
  && cp commons-logging-1.2/commons-logging-1.2.jar /usr/share/maven/lib/

ENV MAVEN_HOME /usr/share/maven

# Use UTF-8
RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen ; locale-gen ; update-locale en_US.UTF-8
ENV LC_ALL "en_US.UTF-8"
ENV LANG "en_US.UTF-8"
ENV LANGUAGE "en_US.UTF-8"
