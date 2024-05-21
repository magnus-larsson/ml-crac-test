# syntax=docker/dockerfile:1.3-labs
# The above syntax directive is required to get support for "RUN --security=insecure"

FROM magnuslarsson/crac_base:1.0.0 as builder

ADD ./build/libs/*.jar app.jar
ADD ./runtime-configuration/application.yaml ./runtime-configuration/application.yaml
# java -Dspring.context.checkpoint=onRefresh -XX:CRaCCheckpointTo=./checkpoint -jar app.jar
RUN --security=insecure SPRING_PROFILES_ACTIVE=p2 SPRING_CONFIG_LOCATION=file:./runtime-configuration/application.yaml ./checkpoint.bash

# TODO: Use a base image optimized for runtime
FROM magnuslarsson/crac_base:1.0.0

COPY --from=builder /app/app.jar app.jar
COPY --from=builder /app/checkpoint checkpoint

EXPOSE 8080
ENTRYPOINT ["java", "-XX:CRaCRestoreFrom=./checkpoint"]
