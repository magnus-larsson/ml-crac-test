# Commands

## Build

Build:
```
./gradlew build  
```

## Tests with local java -jar
Run:
```
SPRING_PROFILES_ACTIVE=p1 SPRING_CONFIG_LOCATION=file:runtime-configuration/application.yaml java -jar build/libs/crac-0.0.1-SNAPSHOT.jar
```

Test:
```
curl localhost:8080/value
```

Expected response:
```
Configured value: RUNTIME P1 VALUE
```

## Tests with CRaC on Docker

Build base image:

```
docker build -f Dockerfile_crac_base -t magnuslarsson/crac_base:1.0.0 .
docker login
docker push magnuslarsson/crac_base:1.0.0
```

Create unsecure buildx builder:

```
# From https://stackoverflow.com/questions/48098671/build-with-docker-and-privileged
docker buildx create --driver-opt image=moby/buildkit:master  \
                     --use --name insecure-builder \
                     --buildkitd-flags '--allow-insecure-entitlement security.insecure'
# ML version:
docker buildx create \
 --use --name ml-insecure-builder \
 --buildkitd-flags '--allow-insecure-entitlement security.insecure'
```

Build OCI image:
```
docker buildx --builder ml-insecure-builder build --allow security.insecure -f Dockerfile -t  ml-crac-test --progress=plain --load .
```

Run OCI image:
```
docker run -it --rm -p 8080:8080 --cap-add=CHECKPOINT_RESTORE --cap-add=SETPCAP ml-crac-test 
```

```
SPRING_PROFILES_ACTIVE=p1 SPRING_CONFIG_LOCATION=file:./runtime-configuration/application.yaml java -jar app.jar
SPRING_PROFILES_ACTIVE=p1 SPRING_CONFIG_LOCATION=file:./runtime-configuration/application.yaml java -XX:CRaCRestoreFrom=./checkpoint
```

Remove builder:

```
docker buildx rm ml-insecure-builder
```
## Tests with CRaC on Ubuntu

```
docker run --privileged -it --rm -p 8080:8080 ubuntu:22.04

HW=$(uname -m)
apt-get update -y
apt-get install curl git -y

cd /opt
curl -LO https://cdn.azul.com/zulu/bin/zulu21.28.89-ca-crac-jdk21.0.0-linux_${HW}.tar.gz

tar -xzf zulu21.28.89-ca-crac-jdk21.0.0-linux_${HW}.tar.gz 
rm zulu21.28.89-ca-crac-jdk21.0.0-linux_${HW}.tar.gz

export JAVA_HOME=/opt/zulu21.28.89-ca-crac-jdk21.0.0-linux_aarch64
export PATH=$JAVA_HOME/bin:$PATH

chown root:root $JAVA_HOME/lib/criu
chmod u+s $JAVA_HOME/lib/criu

java -version

cd ~
git clone https://github.com/magnus-larsson/ml-crac-test.git
cd ml-crac-test
./gradlew build 

SPRING_PROFILES_ACTIVE=p1 SPRING_CONFIG_LOCATION=file:runtime-configuration/application.yaml java -jar build/libs/crac-0.0.1-SNAPSHOT.jar
curl localhost:8080/value
# Returns: "Configured value: RUNTIME P1 VALUE"

java -Dspring.context.checkpoint=onRefresh -XX:CRaCCheckpointTo=checkpoint -jar build/libs/crac-0.0.1-SNAPSHOT.jar
SPRING_PROFILES_ACTIVE=p1 SPRING_CONFIG_LOCATION=file:runtime-configuration/application.yaml java -XX:CRaCRestoreFrom=checkpoint
curl localhost:8080/value
# Returns: "Configured value: DEFAULT VALUE", but expected: "Configured value: RUNTIME P1 VALUE"

rm -rf checkpoint
SPRING_PROFILES_ACTIVE=p1 SPRING_CONFIG_LOCATION=file:runtime-configuration/application.yaml java -Dspring.context.checkpoint=onRefresh -XX:CRaCCheckpointTo=checkpoint -jar build/libs/crac-0.0.1-SNAPSHOT.jar
java -XX:CRaCRestoreFrom=checkpoint
curl localhost:8080/value
# Returns: "Configured value: RUNTIME P1 VALUE"


```