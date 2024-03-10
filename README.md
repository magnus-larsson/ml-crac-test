# Commands

Build:
```
./gradlew build  
```

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
