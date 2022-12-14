#!/bin/sh
set -e

CONFIG_ALL="${PYCSW_CONFIG}/pycsw-all.cfg"
CONFIG_COLLECTION="${PYCSW_CONFIG}/pycsw-collection.cfg"

abort () {
  echo "$@" >&2
  exit 1
}

write_config () {
  sed -i "s\\database=.*$\\$(link_pycsw_postgres_url)\\" $CONFIG_ALL
  sed -i "s\\ckan_url=.*$\\$(link_pycsw_app_url)\\" $CONFIG_ALL
  sed -i "s\\database=.*$\\$(link_pycsw_postgres_url)\\" $CONFIG_COLLECTION
  sed -i "s\\ckan_url=.*$\\$(link_pycsw_app_url)\\" $CONFIG_COLLECTION
}

link_pycsw_postgres_url () {
  local user=$DB_ENV_DB_CKAN_USER
  local pass=$DB_ENV_DB_CKAN_PASSWORD
  local db=$DB_ENV_DB_PYCSW_DB
  local host=$DB_PORT_5432_TCP_ADDR
  local port=$DB_PORT_5432_TCP_PORT
  echo "database=postgresql://${user}:${pass}@${host}/${db}"
}

link_pycsw_app_url () {
  local url=$APP_PORT_80_TCP_ADDR
  local port=$APP_PORT_80_TCP_PORT
  echo "ckan_url=http://${url}:${port}/"
}

write_config
