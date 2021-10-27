# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Bandiera::WebAuditContext do
  subject { described_class.new(request) }

  let(:request) { Rack::Request.new(Rack::MockRequest.env_for('/a/path', 'REMOTE_ADDR' => '1.2.3.4')) }

  it_behaves_like 'an audit context'

  describe '#user_id' do
    it 'returns the current remote IP address' do
      expect(subject.user_id).to eq('1.2.3.4')
    end
  end
end
