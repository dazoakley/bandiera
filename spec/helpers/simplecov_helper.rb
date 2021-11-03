# frozen_string_literal: true

require 'simplecov'

SimpleCov.start do
  load_profile 'test_frameworks'
  merge_timeout 3600
  coverage_dir 'artifacts/coverage'
end
