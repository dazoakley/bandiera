# frozen_string_literal: true

APP_ROOT = File.expand_path(File.dirname(File.dirname(__FILE__)))

$LOAD_PATH.unshift File.join(APP_ROOT, 'lib')

require 'bandiera'

port              = Integer(ENV['PORT'] || 5000)
no_of_processes   = Integer(ENV['PROCESSES'] || 0)
min_no_of_threads = Integer(ENV['MIN_THREADS'] || 8)
max_no_of_threads = Integer(ENV['MAX_THREADS'] || 32)

tag               'bandiera'
environment       ENV['RACK_ENV'] || 'production'
worker_timeout    15

threads           min_no_of_threads, max_no_of_threads
workers           no_of_processes

bind              "tcp://0.0.0.0:#{port}"

preload_app!

on_worker_boot do
  Bandiera::Db.disconnect
  Bandiera::Db.connect
end
