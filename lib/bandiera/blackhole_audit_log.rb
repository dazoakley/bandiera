module Bandiera
  class BlackholeAuditLog
    def record_add_object(_audit_context, _object)
      # no-op
    end

    def record_update_object(_audit_context, _old_object, _new_object)
      # no-op
    end

    def record_delete_object(_audit_context, _object)
      # no-op
    end
  end
end
