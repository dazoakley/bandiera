# frozen_string_literal: true

shared_examples_for 'an audit log' do
  describe 'logging methods' do
    it 'responds to #record_add_object' do
      expect(subject).to respond_to(:record_add_object).with(2).arguments
    end

    it 'responds to #record_update_object' do
      expect(subject).to respond_to(:record_update_object).with(3).arguments
    end

    it 'responds to #record_delete_object' do
      expect(subject).to respond_to(:record_delete_object).with(2).arguments
    end
  end
end
