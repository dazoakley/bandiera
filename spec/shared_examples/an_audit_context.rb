# frozen_string_literal: true

shared_examples_for 'an audit context' do
  describe 'auditing information' do
    it 'responds to #user_id?' do
      expect(subject).to respond_to(:user_id).with(0).arguments
    end
  end
end
