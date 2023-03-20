#!/bin/bash

MUMUKI_BIBLIOTHECA_API_URL=http://bibliotheca-api.mumuki.io MUMUKI_THESAURUS_URL=http://thesaurus.mumuki.io bundle exec rake db:drop db:create db:schema:load db:seed
bundle exec rake db:migrate
