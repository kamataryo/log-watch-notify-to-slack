#!/bin/sh

NOTIFY_WEBHOOK='webhook url'
#LOG_FOLDER1=/data/pgsql/data/pg_log
#LOG_FOLDER2=/data3/data5433/pg_log

notify() {
  echo $1
  LAST_LINE=$(tail -n 1 $1)
  curl
    -X POST \
    -H 'Content-type: application/json' \
    --data "{\"text\":\"${LAST_LINE}\"}" \
    $NOTIFY_WEBHOOK

}

if [ ! $1 ] || [ $1 = '' ]; then
  echo 'ファイル名/フォルダ名を指定してください。'
  exit 1
fi

if [ -d $1 ]; then
  while read LINE
  do
    tail -n 0 --F --retry $LINE | notify
  done < "$(find $1 -type f)"
elif [ -f $1 ]; then
  tail -n0 -F $1 | notify
else
  echo '有効なファイル名/フォルダ名を指定してください。'
  exit 2
fi
