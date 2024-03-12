#!/usr/bin/env bash

# v1

OUT_FOLDER=./checkpoint
echo Checkpointing to $OUT_FOLDER...
# Will return 137 on successfull checkpointing, needs to be wrqpped to avoid the image build to fail
# java -Dspring.context.checkpoint=onRefresh -XX:CRaCCheckpointTo=$OUT_FOLDER -jar build/libs/product-service-1.0.0-SNAPSHOT.jar
java -Dspring.context.checkpoint=onRefresh -XX:CRaCCheckpointTo=$OUT_FOLDER -jar app.jar
echo RESULT $?
exit 0
