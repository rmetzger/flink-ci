FROM maven:3.6-jdk-8

# install gosu
RUN set -eux; \
	apt-get update; \
	apt-get install -y gosu sudo; \
	rm -rf /var/lib/apt/lists/*;

# add user to execute Flink tests (they can't execute as root)
RUN useradd -ms /bin/bash user
RUN echo "user ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers


ENV MAVEN_CONFIG "/home/user/.m2"
ENV JAVA_HOME_8_X64 "/usr/local/openjdk-8"
WORKDIR /home/user/flink
