#!/usr/bin/env rake
# frozen_string_literal: true

$LOAD_PATH.unshift("#{File.dirname(__FILE__)}/lib")
require 'bandiera'
require 'bandiera/anonymous_audit_context'

begin
  require 'rspec/core/rake_task'

  RSpec::Core::RakeTask.new

  task default: :spec

  desc 'Run the test suite (RSpec)'
  task test: :spec
rescue LoadError
  warn 'Could not load RSpec tasks'
end

namespace :db do
  desc 'Run DB migrations'
  task :migrate do
    Bandiera::Db.migrate
  end

  desc 'Rollback the DB'
  task :rollback do
    Bandiera::Db.rollback
  end

  task dev_setup: %i[migrate] do
    db   = Bandiera::Db.connect
    serv = Bandiera::FeatureService.new

    db[:groups].delete
    db[:features].delete
    db[:audit_records].delete

    serv.add_features(
      Bandiera::AnonymousAuditContext.new,
      [
        { group:       'pubserv',
          name:        'show-article-metrics',
          description: 'Show metrics on the article pages?',
          active:      true },
        { group:       'pubserv',
          name:        'show-new-search',
          description: 'Show the new search feature?',
          active:      true,
          percentage:  50 },
        { group:       'pubserv',
          name:        'show-reorganised-homepage',
          description: 'Show the new homepage layout?',
          active:      true,
          user_groups: { list: ['editor'], regex: '' } }
      ]
    )
  end
end
