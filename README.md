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
```