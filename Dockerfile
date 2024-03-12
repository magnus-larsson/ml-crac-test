# syntax=docker/dockerfile:1.3-labs

## docker buildx --builder ml-insecure-builder build --allow security.insecure -f Dockerfile -t  ml-crac-test --progress=plain --load .
##
## # Run
##
## docker run --rm -p 7001:7001 --cap-add=CHECKPOINT_RESTORE --cap-add=SETPCAP crac-product-service

FROM ubuntu:22.04 as builder
WORKDIR app

RUN apt-get update -y

ADD "https://cdn.azul.com/zulu/bin/zulu21.28.89-ca-crac-jdk21.0.0-linux_aarch64.tar.gz" /opt/
RUN cd /opt/ && tar -xzf zulu21.28.89-ca-crac-jdk21.0.0-linux_aarch64.tar.gz && rm zulu21.28.89-ca-crac-jdk21.0.0-linux_aarch64.tar.gz

ENV JAVA_HOME /opt/zulu21.28.89-ca-crac-jdk21.0.0-linux_aarch64
ENV PATH $JAVA_HOME/bin:$PATH

RUN chown root:root $JAVA_HOME/lib/criu
RUN chmod u+s $JAVA_HOME/lib/criu

RUN java -version

RUN apt-get update -y
RUN apt-get install unzip curl -y

ADD ./build/libs/*.jar app.jar
RUN ls -al *

ADD ./runtime-configuration/application.yaml ./runtime-configuration/application.yaml
RUN ls -al ./runtime-configuration

ADD crac/checkpoint.bash ./checkpoint.bash

# Docker version
RUN --security=insecure SPRING_PROFILES_ACTIVE=p2 SPRING_CONFIG_LOCATION=file:./runtime-configuration/application.yaml ./checkpoint.bash

RUN ls -al ./checkpoint

EXPOSE 8080
ENV SPRING_PROFILES_ACTIVE=p1
ENTRYPOINT ["java", "-XX:CRaCRestoreFrom=./checkpoint"]
