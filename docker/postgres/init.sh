#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
  create role mumuki with createdb login password 'mumuki';

  # CREATE DATABASE magistrades_development;
  # CREATE DATABASE magistrades_test;
EOSQL
