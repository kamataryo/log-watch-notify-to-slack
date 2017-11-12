#!/bin/sh

NOTIFY_WEBHOOK='webhook url'
FILTER="[fatal]"

tail -n0 -F "$1" | while read LINE; do
  (echo "$LINE" | grep -e "$FILTER") && curl -X POST --silent --data-urlencode \
    "payload={\"text\": \"$(echo $LINE | sed "s/\"/'/g")\"}" "$NOTIFY_WEBHOOK";
done
