workers Integer(ENV['MUMUKI_LABORATORY_WORKERS'] || 2)
threads_count = Integer(ENV['MUMUKI_LABORATORY_THREADS'] || 1)
threads threads_count, threads_count

preload_app!

# rackup      DefaultRackup
port        ENV['MUMUKI_LABORATORY_PORT']       || 3000
environment ENV['RAILS_ENV'] || ENV['RACK_ENV'] || 'development'

on_worker_boot do
  ActiveRecord::Base.establish_connection if defined?(ActiveRecord)
  Mumukit::Nuntius.establish_connection
end
