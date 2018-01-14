## Require code
require ::File.expand_path('../config/environment',  __FILE__)

## Essential parameters validation
raise 'Missing secret key' unless Mumukit::Login.config.mucookie_secret_key

## Start server
run Rails.application
