#!/usr/bin/env bash

# Load the environment configuration
PID=$1
PATH=$PATH:/opt/factorio/bin
source /opt/factorio/config/factorio.env
source ${FACTORIO_PATH}/bin/init-env.sh
load_config

PLAYER_CHECK_COUNT=0
PLAYER_CHECK_MAX=300
while [ ${PLAYER_CHECK_COUNT} -lt ${PLAYER_CHECK_MAX} ]; do
  PLAYERS=$(cmd_players online | wc -l)
  if [ ${PLAYERS} -ne 0 ]; then
    TIME_LEFT=$((${PLAYER_CHECK_MAX} / 60))
    send_cmd "[SERVER NOTICE: $(date +"%m-%d-%Y %H:%M:%S")]"
    send_cmd "Server shutting down in ${TIME_LEFT} minutes!"
    send_cmd "Please log out to avoid the risk of losing progress or being stuck in a bad location!"
    send_cmd "-- End of line --"
    PLAYER_CHECK_COUNT=$((${PLAYER_CHECK_COUNT}+60))
  else
    send_cmd "Server shutting down NOW!"
    sleep 5
    break
  fi
  sleep 60
done

if kill -TERM "${PID}" 2> /dev/null; then
  sec=1
  while [ "$sec" -le "${FORCED_SHUTDOWN}" ]; do
    if kill -0 "${PID}" 2> /dev/null; then
      echo -n ". "
      sleep 1
    else
      break
    fi
    sec=$((sec+1))
  done
fi

if kill -0 "${PID}" 2> /dev/null; then
  echo "Unable to shut down nicely, killing the process!"
  kill -KILL "${PID}" 2> /dev/null
  rm -f ${PIDFILE}
else
  echo "complete!"
  rm -f ${PIDFILE}
fi