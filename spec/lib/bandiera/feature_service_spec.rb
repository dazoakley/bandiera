# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Bandiera::FeatureService do
  subject { described_class.new(audit_log) }

  let(:audit_context) { Bandiera::AnonymousAuditContext.new }
  let(:audit_log) { Bandiera::AuditLogger.new }

  it_behaves_like 'a feature service'

  describe '#add_group' do
    it 'records to the audit log' do
      expect(audit_log).to receive(:record_add_object).once
      subject.add_group(audit_context, 'cheese')
    end
  end

  describe '#add_feature' do
    it 'records to the audit log' do
      subject.add_group(audit_context, 'group')

      expect(audit_log)
        .to receive(:record_add_object)
        .with(audit_context, instance_of(Bandiera::Feature))

      subject.add_feature(audit_context, name: 'feat', group: 'group', active: false)
    end
  end

  describe '#add_features' do
    it 'records to the audit log' do
      subject.add_group(audit_context, 'group')

      expect(audit_log)
        .to receive(:record_add_object)
        .with(audit_context, instance_of(Bandiera::Feature))
        .exactly(3).times

      subject.add_features(audit_context, [
                             { name: 'feature1', group: 'group' },
                             { name: 'feature2', group: 'group' },
                             { name: 'feature3', group: 'group' }
                           ])
    end
  end

  describe '#remove_feature' do
    it 'records to the audit log' do
      subject.add_feature(audit_context, { name: 'feat', group: 'group', description: '', active: false })

      expect(audit_log)
        .to receive(:record_delete_object)
        .with(audit_context, instance_of(Bandiera::Feature))

      subject.remove_feature(audit_context, 'group', 'feat')
    end
  end

  describe '#update_feature' do
    it 'records to the audit log' do
      subject.add_feature(audit_context, { name: 'feat', group: 'group', description: '', active: false })

      expect(audit_log)
        .to receive(:record_update_object)
        .with(audit_context, instance_of(Bandiera::Feature), instance_of(Bandiera::Feature))

      subject.update_feature(audit_context, 'group', 'feat', description: 'updated', active: true)
    end
  end
end
