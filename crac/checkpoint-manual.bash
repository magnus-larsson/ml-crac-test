#!/usr/bin/env bash

: ${JAR_FILE=app.jar}
: ${OUT_FOLDER=./checkpoint}

echo Checkpointing application $JAR_FILE to folder $OUT_FOLDER...

echo "Sleeping..." && sleep 10 && echo "Sleep is over!" && jcmd app.jar JDK.checkpoint &

# Will return 137 on a successfull checkpoint, needs to be wrapped to avoid the image build to fail
java -XX:CRaCCheckpointTo=$OUT_FOLDER -jar $JAR_FILE
result=$?
if [ "$result" -eq "137" ]; then
  # Replace exit code 137 with 0 (i.e. success)
  exit 0
else
  echo Checkpointing failed with the status $result
  exit 1;
fi
