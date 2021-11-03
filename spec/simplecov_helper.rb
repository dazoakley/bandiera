# frozen_string_literal: true

require 'simplecov'
require 'simplecov-rcov'

SimpleCov.formatter = SimpleCov::Formatter::HTMLFormatter

SimpleCov.start do
  load_profile 'test_frameworks'
  merge_timeout 3600
  coverage_dir 'artifacts/coverage'
end
