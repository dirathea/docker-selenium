#!/bin/bash

ROOT=/opt/selenium
CONF=$ROOT/config.json

$ROOT/generate_config >$CONF

echo "starting selenium hub with configuration:"
cat $CONF

if [ ! -z "$SE_OPTS" ]; then
  echo "appending selenium options: ${SE_OPTS}"
fi

function shutdown {
    echo "shutting down hub.."
    kill -s SIGTERM $NODE_PID
    wait $NODE_PID
    echo "shutdown complete"
}

java ${JAVA_OPTS} -cp /opt/selenium/selenium-server-standalone.jar:/opt/selenium/custom-capability-matcher/target/custom-capability-matcher-1.0-SNAPSHOT.jar \
  org.openqa.grid.selenium.GridLauncher \
  -role hub \
  -hubConfig $CONF \
  ${SE_OPTS} &
NODE_PID=$!

trap shutdown SIGTERM SIGINT
wait $NODE_PID
