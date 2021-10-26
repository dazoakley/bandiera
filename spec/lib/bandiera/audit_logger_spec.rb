require 'spec_helper'

RSpec.describe Bandiera::AuditLogger do
  let(:db) { Bandiera::Db.connect }
  let(:audit_context) { Bandiera::AnonymousAuditContext.new }
  subject { Bandiera::AuditLogger.new(db) }

  let(:group_obj) { Bandiera::Group.create(name: 'foo') }
  let(:feature_obj) { Bandiera::Feature.create(group: group_obj, name: 'foo-feat', active: true)}

  it_behaves_like 'an audit log'

  describe '#record_add_object' do
    it 'records the creation of a new group object to the audit log' do
      expect(db[:audit_records]).to be_empty

      subject.record_add_object(audit_context, group_obj)

      audit_record = db[:audit_records].first
      expect(audit_record).to_not be_nil
      expect(audit_record[:user]).to eq('<anonymous>')
      expect(audit_record[:action]).to eq('create')
      expect(audit_record[:object]).to eq('Bandiera::Group')
      expect(audit_record[:object_id]).to eq(group_obj.id)
      expect(audit_record[:new_object]).to eq(group_obj.to_json)
    end

    it 'records the creation of a new feature object to the audit log' do
      expect(db[:audit_records]).to be_empty

      subject.record_add_object(audit_context, feature_obj)

      audit_record = db[:audit_records].first
      expect(audit_record).to_not be_nil
      expect(audit_record[:user]).to eq('<anonymous>')
      expect(audit_record[:action]).to eq('create')
      expect(audit_record[:object]).to eq('Bandiera::Feature')
      expect(audit_record[:object_id]).to eq(feature_obj.id)
      expect(audit_record[:new_object]).to eq(feature_obj.to_json(except: [:created_at, :updated_at]))
    end

    it 'sets the timestamp to the current time' do
      expect(db[:audit_records]).to be_empty
      expected_time = Time.local(2017, 1, 1, 12, 0, 0)

      Timecop.freeze(expected_time) do
        subject.record_add_object(audit_context, feature_obj)
      end

      audit_record = db[:audit_records].first
      expect(audit_record).to_not be_nil
      expect(audit_record[:timestamp]).to eq(expected_time)
    end

    it 'does not propogate exceptions' do
      audit_record = instance_double('Bandiera::AuditRecord')
      expect(Bandiera::AuditRecord).to receive(:create).and_throw RuntimeError.new('This should not propagate')

      subject.record_add_object(audit_context, feature_obj)
    end
  end

  describe '#record_update_object' do
    it 'records the update of a group object to the audit log' do
      expect(db[:audit_records]).to be_empty

      older = group_obj.dup
      older_json = older.to_json(except: [:created_at, :updated_at])
      newer = group_obj.update(name: 'bar')
      newer_json = newer.to_json(except: [:created_at, :updated_at])

      subject.record_update_object(audit_context, older, newer)

      audit_record = db[:audit_records].first
      expect(audit_record).to_not be_nil
      expect(audit_record[:user]).to eq('<anonymous>')
      expect(audit_record[:action]).to eq('update')
      expect(audit_record[:object]).to eq('Bandiera::Group')
      expect(audit_record[:object_id]).to eq(older.id)
      expect(audit_record[:old_object]).to eq(older_json)
      expect(audit_record[:new_object]).to eq(newer_json)
    end

    it 'records the update of a feature object to the audit log' do
      expect(db[:audit_records]).to be_empty

      older = feature_obj.dup
      older_json = older.to_json(except: [:created_at, :updated_at])
      newer = feature_obj.update(name: 'bar-feat')
      newer_json = newer.to_json(except: [:created_at, :updated_at])

      subject.record_update_object(audit_context, older, newer)

      audit_record = db[:audit_records].first
      expect(audit_record).to_not be_nil
      expect(audit_record[:user]).to eq('<anonymous>')
      expect(audit_record[:action]).to eq('update')
      expect(audit_record[:object]).to eq('Bandiera::Feature')
      expect(audit_record[:object_id]).to eq(older.id)
      expect(audit_record[:old_object]).to eq(older_json)
      expect(audit_record[:new_object]).to eq(newer_json)
    end

    it 'sets the timestamp to the current time' do
      expect(db[:audit_records]).to be_empty
      expected_time = Time.local(2017, 1, 1, 12, 0, 0)

      older = feature_obj.dup
      newer = feature_obj.update(name: 'bar-feat')

      Timecop.freeze(expected_time) do
        subject.record_update_object(audit_context, older, newer)
      end

      audit_record = db[:audit_records].first
      expect(audit_record).to_not be_nil
      expect(audit_record[:timestamp]).to eq(expected_time)
    end

    it 'does not propogate exceptions' do
      audit_record = instance_double('Bandiera::AuditRecord')
      expect(Bandiera::AuditRecord).to receive(:create).and_throw RuntimeError.new('This should not propagate')

      subject.record_update_object(audit_context, feature_obj, feature_obj)
    end
  end

  describe '#record_delete_object' do
    it 'records the deletion of a group object to the audit log' do
      expect(db[:audit_records]).to be_empty

      subject.record_delete_object(audit_context, group_obj)

      audit_record = db[:audit_records].first
      expect(audit_record).to_not be_nil
      expect(audit_record[:user]).to eq('<anonymous>')
      expect(audit_record[:action]).to eq('delete')
      expect(audit_record[:object]).to eq('Bandiera::Group')
      expect(audit_record[:object_id]).to eq(group_obj.id)
      expect(audit_record[:old_object]).to eq(group_obj.to_json)
    end

    it 'records the deletion of a feature object to the audit log' do
      expect(db[:audit_records]).to be_empty

      subject.record_delete_object(audit_context, feature_obj)

      audit_record = db[:audit_records].first
      expect(audit_record).to_not be_nil
      expect(audit_record[:user]).to eq('<anonymous>')
      expect(audit_record[:action]).to eq('delete')
      expect(audit_record[:object]).to eq('Bandiera::Feature')
      expect(audit_record[:object_id]).to eq(feature_obj.id)
      expect(audit_record[:old_object]).to eq(feature_obj.to_json(except: [:created_at, :updated_at]))
    end

    it 'sets the timestamp to the current time' do
      expect(db[:audit_records]).to be_empty
      expected_time = Time.local(2017, 1, 1, 12, 0, 0)

      Timecop.freeze(expected_time) do
        subject.record_delete_object(audit_context, feature_obj)
      end

      audit_record = db[:audit_records].first
      expect(audit_record).to_not be_nil
      expect(audit_record[:timestamp]).to eq(expected_time)
    end

    it 'does not propogate exceptions' do
      audit_record = instance_double('Bandiera::AuditRecord')
      expect(Bandiera::AuditRecord).to receive(:create).and_throw RuntimeError.new('This should not propagate')

      subject.record_delete_object(audit_context, feature_obj)
    end
  end
end
