#!/bin/bash

set -e

CONF_DIR='/etc/varnish'
PIDFILE=/run/varnish.pid
SECRET_FILE="$CONF_DIR/secret"

# Check if conf directory is empty as it might be mounted as a volume to the host
# https://www.cyberciti.biz/faq/linux-unix-shell-check-if-directory-empty/
if [ "$(ls -A $CONF_DIR)" ]; then
  echo "$CONF_DIR is not empty. We are ok to go."
else
  echo "$CONF_DIR directory is empty. It might be mounted as a volume to the host. Copying initial conf files."
  cp -Rp /orig/conf/* "$CONF_DIR"/
fi

# Check if secret file exists in conf directory. If it does not exist
# then create it.
# https://varnish-cache.org/docs/trunk/users-guide/run_security.html#cli-interface-authentication
if [ -a "$SECRET_FILE" ]; then
  echo "$SECRET_FILE exists. We are ok to go."
else
  echo "$SECRET_FILE file does not exist. Creating a new one." \
  && dd if=/dev/random of="${SECRET_FILE}" count=1 \
  && echo "$SECRET_FILE successfully created!"
fi

# Print Varnish version before starting
/usr/sbin/varnishd -V

# Start Varnish
exec bash -c \
  "exec varnishd -F \
  -a :6081 \
  -T localhost:6082 \
  -S $SECRET_FILE \
  -P $PIDFILE \
  -f $VCL_CONFIG \
  -s malloc,$CACHE_SIZE \
  $VARNISHD_PARAMS"
