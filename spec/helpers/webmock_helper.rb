# frozen_string_literal: true

require 'webmock/rspec'

WebMock.disable_net_connect!(allow_localhost: true)

RSpec.configure do |config|
  config.after do
    WebMock.reset!
  end

  config.after(:suite) do
    WebMock.disable!
  end
end
