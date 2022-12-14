#!/bin/bash


# configure ini files
/bin/sh /usr/local/bin/pycsw_config.sh

if [ "$1" = 'start-pycsw' ]; then

  # wait for all services to start-up
  if [ "$2" = '--wait-for-dependencies' ]; then
      sh -c "while ! nc -w 1 -z $DB_PORT_5432_TCP_ADDR $DB_PORT_5432_TCP_PORT; do sleep 1; done"
  fi

  # initialize DB
  /usr/lib/pycsw/bin/pycsw-ckan.py -c setup_db -f /etc/pycsw/pycsw-all.cfg

  # start apache2
  /bin/bash -c "source /etc/apache2/envvars && exec /usr/sbin/apache2 -DFOREGROUND"

elif [ "$1" = 'load-pycsw' ]; then

    /usr/lib/pycsw/bin/pycsw-ckan.py -c load -f /etc/pycsw/pycsw-all.cfg

    /usr/lib/pycsw/bin/pycsw-db-admin.py vacuumdb /etc/pycsw/pycsw-all.cfg

elif [ "$1" = 'set_keywords' ]; then

    /usr/lib/pycsw/bin/pycsw-ckan.py -c set_keywords -f /etc/pycsw/pycsw-all.cfg

elif [ "$1" = 'reindex-fts' ]; then

    /usr/lib/pycsw/bin/pycsw-db-admin.py reindex_fts /etc/pycsw/pycsw-all.cfg

else
    # execute any other command
    exec $@
fi
