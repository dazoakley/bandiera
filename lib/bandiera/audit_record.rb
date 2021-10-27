# frozen_string_literal: true

module Bandiera
  class AuditRecord < Sequel::Model
    def before_save
      self.timestamp ||= Time.now
      super
    end
  end
end
