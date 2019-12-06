## flink-ci Docker container

# Building

```
docker build -t rmetzger/flink-ci:latest .
```

Publishing

```
docker push rmetzger/flink-ci:latest
```

# Running

```
docker run -it -v `pwd`/flink:/home/user/flink -v `pwd`/.m2:/home/user/.m2  rmetzger/flink-ci mvn clean install
```

Explore running container by `docker ps` and `docker exec -it dc3ddc078bc8 bash`

Explore a container with `docker run -it rmetzger/flink-ci:latest bash`
