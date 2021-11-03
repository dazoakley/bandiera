# frozen_string_literal: true

$LOAD_PATH.unshift File.join(__FILE__, '../lib')

require 'bandiera'
Bandiera.init

if ENV['AIRBRAKE_API_KEY'] && ENV['AIRBRAKE_PROJECT_ID']
  require 'socket'
  require 'airbrake'

  Airbrake.configure do |config|
    config.project_key = ENV['AIRBRAKE_API_KEY']
    config.project_id  = ENV['AIRBRAKE_PROJECT_ID']
  end

  Airbrake.add_filter do |notice|
    notice.ignore! if notice[:errors].any? { |error| error[:type] == 'Sinatra::NotFound' }
  end
end

if ENV['SENTRY_DSN']
  require 'raven'

  Raven.configure do |config|
    config.dsn                 = ENV['SENTRY_DSN']
    config.current_environment = ENV.fetch('RACK_ENV', 'development')
    config.environments        = ['production']
    config.logger              = Bandiera.logger
  end

  use Raven::Rack
end

if ENV['RACK_CORS_ORIGINS']
  require 'rack/cors'

  use Rack::Cors do
    allow do
      origins ENV['RACK_CORS_ORIGINS']
      resource '/api/v2/*', headers: :any, methods: %i[get options]
    end
  end
end

require 'rack'
require 'prometheus/middleware/collector'
require 'prometheus/middleware/exporter'
use Rack::Deflater
use Prometheus::Middleware::Collector
use Prometheus::Middleware::Exporter

require 'rack/not_so_common_logger'
use Rack::NotSoCommonLogger, Bandiera.logger
use Airbrake::Rack::Middleware if ENV['AIRBRAKE_API_KEY'] && ENV['AIRBRAKE_PROJECT_ID']

run Rack::URLMap.new(
  '/'       => Bandiera::GUI,
  '/api/v1' => Bandiera::APIv1,
  '/api/v2' => Bandiera::APIv2
)
