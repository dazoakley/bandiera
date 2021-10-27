# frozen_string_literal: true

module Bandiera
  class AnonymousAuditContext
    def user_id
      '<anonymous>'
    end
  end
end
