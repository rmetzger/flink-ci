FROM maven:3.6-jdk-8

# install gosu
RUN set -eux; \
	apt-get update; \
	apt-get install -y gosu sudo; \
	rm -rf /var/lib/apt/lists/*;

# add user to execute Flink tests (they can't execute as root)
RUN useradd -ms /bin/bash user
RUN echo "user ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

ENV JAVA_HOME_8_X64 "/usr/local/openjdk-8/"
ENV MAVEN_CONFIG "/home/user/.m2"

# make the "mvn" command use gosu for running as 'user' by default
# The Flink tests require non-root permissions for some file permissions tests
RUN mv /usr/share/maven/bin/mvn /usr/share/maven/bin/vanilla-mvn
RUN echo "#!/bin/sh" >> /usr/share/maven/bin/mvn
RUN echo 'gosu user /usr/share/maven/bin/vanilla-mvn $@' >> /usr/share/maven/bin/mvn
RUN chmod +x /usr/share/maven/bin/mvn

WORKDIR /home/user/flink
