# frozen_string_literal: true

require 'date'
require 'dotenv'
require 'json'
require 'logger'
require 'prometheus/client'
require 'sequel'
require_relative 'hash'

GC::Profiler.enable

module Bandiera
  autoload :Db,                     'bandiera/db'
  autoload :WebAuditContext,        'bandiera/web_audit_context'
  autoload :AuditLogger,            'bandiera/audit_logger'
  autoload :AuditRecord,            'bandiera/audit_record'
  autoload :Group,                  'bandiera/group'
  autoload :Feature,                'bandiera/feature'
  autoload :FeatureService,         'bandiera/feature_service'
  autoload :CachingFeatureService,  'bandiera/caching_feature_service'
  autoload :WebAppBase,             'bandiera/web_app_base'
  autoload :APIv1,                  'bandiera/api_v1'
  autoload :APIv2,                  'bandiera/api_v2'
  autoload :GUI,                    'bandiera/gui'

  class << self
    def init
      Dotenv.load
      Db.connect
    end

    attr_writer :logger

    def logger
      return @logger if @logger

      @logger = Logger.new($stdout)

      if ENV['STACKDRIVER_JSON_LOGGER']
        require 'logger/stackdriver_json_formatter'
        @logger.formatter = Logger::StackdriverJsonFormatter.new
      end

      @logger.level = Logger.const_get(ENV.fetch('LOG_LEVEL', 'INFO').upcase)

      @logger
    end

    def version
      ENV.fetch('VERSION', 'local')
    end

    def revision
      ENV.fetch('REVISION', 'gitsha')
    end

    def build_time
      ENV.fetch('BUILDTIME', DateTime.now.iso8601)
    end
  end
end
