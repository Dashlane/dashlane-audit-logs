#! /bin/bash

if [ -z "${DASHLANE_CLI_TIMESTAMP}" ]
then
    DASHLANE_CLI_TIMESTAMP=$(date -d '1 day ago' +%s000)
fi

while true
do
    DASHLANE_CLI_RESULT=$(dcli t l --start $DASHLANE_CLI_TIMESTAMP --end now)
    echo $DASHLANE_CLI_RESULT | /opt/fluent-bit/bin/fluent-bit -c $DASHLANE_CLI_FLUENTBIT_CONF -q
    DASHLANE_CLI_TIMESTAMP=$(echo $DASHLANE_CLI_RESULT | jq '.date_time' | head -n1)
    sleep $DASHLANE_CLI_RUN_DELAY
done