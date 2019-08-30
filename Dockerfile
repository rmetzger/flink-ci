FROM maven:3.6-jdk-8

# install gosu
RUN set -eux; \
	apt-get update; \
	apt-get install -y gosu; \
	rm -rf /var/lib/apt/lists/*;

# add user to execute Flink tests (they can't execute as root)
RUN useradd -ms /bin/bash user


ENV MAVEN_CONFIG "/home/user/.m2"
WORKDIR /home/user/flink
