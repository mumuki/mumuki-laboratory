#!/bin/bash

# create db user for linux users
psql <<EOF
  create role mumuki with createdb login password 'mumuki';
EOF
