# frozen_string_literal: true

module Bandiera
  class FeatureService
    class GroupNotFound < StandardError
      def message
        'This group does not exist in the Bandiera database.'
      end
    end

    class FeatureNotFound < StandardError
      def message
        'This feature does not exist in the Bandiera database.'
      end
    end

    attr_reader :audit_log

    def initialize(audit_log = AuditLogger.new, db = Db.connect)
      @audit_log = audit_log
      @db = db
    end

    # Groups

    def find_group(name)
      group = Group.find(name: name)
      raise GroupNotFound, "Cannot find group '#{name}'" unless group

      group
    end

    def add_group(audit_context, group)
      result = Group.create(name: group)
      audit_log.record_add_object(audit_context, result)
      result
    end

    def find_or_create_group(audit_context, name)
      group = Group.find(name: name)
      group ||= add_group(audit_context, name)
      group
    end

    def fetch_groups
      Group.order(Sequel.asc(:name))
    end

    def fetch_group_features(group_name)
      find_group(group_name).features
    end

    # Features

    def fetch_feature(group, name)
      group_id = find_group_id(group)
      feature = Feature.first(group_id: group_id, name: name)
      raise FeatureNotFound, "Cannot find feature '#{name}'" unless feature

      feature
    end

    def add_feature(audit_context, data)
      data[:group] = find_or_create_group(audit_context, data[:group])

      if Feature.find(name: data[:name], group_id: data[:group].id)
        # FIXME: should we really be updating here? Refactor?
        update_feature(audit_context, data[:group].name, data[:name], data)
      else
        feature = Feature.create(data)
        audit_log.record_add_object(audit_context, feature)
        feature
      end
    end

    def add_features(audit_context, features)
      features.map { |feature| add_feature(audit_context, feature) }
    end

    def remove_feature(audit_context, group, name)
      feature = fetch_feature(group, name)
      raise FeatureNotFound, "Cannot find feature '#{name}'" if feature.nil?

      audit_log.record_delete_object(audit_context, feature)
      feature.delete
    end

    def update_feature(audit_context, group, name, params)
      feature = fetch_feature(group, name)
      raise FeatureNotFound, "Cannot find feature '#{name}'" if feature.nil?

      fields = {
        description: params[:description],
        active:      params[:active],
        user_groups: params[:user_groups],
        percentage:  params[:percentage],
        start_time:  params[:start_time],
        end_time:    params[:end_time]
      }.delete_if { |_k, v| v.nil? }

      original_feature = feature.dup
      updated_feature = feature.update(fields)
      audit_log.record_update_object(audit_context, original_feature, updated_feature)
      updated_feature
    end

    private

    def find_group_id(name)
      group_id = Group.where(name: name).get(:id)
      raise GroupNotFound, "Cannot find group '#{name}'" unless group_id

      group_id
    end

    attr_reader :db
  end
end
