# frozen_string_literal: true

ENV['RACK_ENV'] = 'test'

require_relative 'helpers/webmock_helper'
require_relative 'helpers/simplecov_helper'
require 'macmillan/utils/statsd_stub'

require 'timecop'
require 'pry'

require_relative '../lib/bandiera'
require_relative '../lib/bandiera/anonymous_audit_context'
load File.expand_path('../Rakefile', __dir__)

# load shared_examples
shared_example_files = File.expand_path('shared_examples/**/*.rb', __dir__)
Dir[shared_example_files].sort.each(&method(:require))

# Suppress logging
Bandiera.logger = Logger.new('/dev/null')
Bandiera.statsd = Macmillan::Utils::StatsdStub.new

# use an in-memory sqlite database for testing
ENV['DATABASE_URL'] = 'sqlite:/'

DB = Bandiera::Db.connect
Bandiera::Db.migrate

RSpec.configure do |config|
  config.after do
    DB[:features].delete
    DB[:groups].delete
    DB[:audit_records].delete
  end

  config.disable_monkey_patching!

  config.default_formatter = 'doc' if config.files_to_run.one?

  config.order = :random
  Kernel.srand config.seed
end
