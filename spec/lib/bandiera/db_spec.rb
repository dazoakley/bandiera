# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Bandiera::Db do
  subject { described_class.connect }

  describe 'the features table' do
    it 'is present' do
      expect(subject.tables).to include(:groups)
      expect(subject.tables).to include(:features)
    end

    it 'is empty' do
      expect(subject[:groups]).to be_empty
      expect(subject[:features]).to be_empty
    end

    it 'allows us to enter data' do
      subject[:groups] << { name: 'qwerty' }

      group = subject[:groups].first

      subject[:features] << { group_id: group[:id], name: 'woo' }
      subject[:features] << { group_id: group[:id], name: 'woo2' }
      expect(subject[:features].count).to eq(2)
    end
  end

  describe '#ready?' do
    context 'when the database is up and ready' do
      it 'returns true' do
        expect(described_class.ready?).to be true
      end
    end

    context 'when the database is not available' do
      let(:connection_double) { double(:connection) }

      before do
        allow(described_class).to receive(:connect).and_return(connection_double)
        allow(connection_double).to receive(:execute).and_raise(Sequel::DatabaseDisconnectError, 'Boom')
      end

      it 'returns false' do
        expect(described_class.ready?).to be false
      end
    end
  end
end
