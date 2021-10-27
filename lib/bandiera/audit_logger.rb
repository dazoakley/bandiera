# frozen_string_literal: true

module Bandiera
  class AuditLogger
    def initialize(db = Db.connect)
      @db = db
    end

    def record_add_object(audit_context, object)
      AuditRecord.create(
        user:       audit_context.user_id,
        action:     :create,
        object:     object.class,
        object_id:  object.id,
        new_object: object.to_json(except: %i[updated_at created_at])
      )
    rescue StandardError => e
      Bandiera.logger.error("Audit logging (#record_add_object) failed: #{e.message}")
    end

    def record_update_object(audit_context, old_object, new_object)
      AuditRecord.create(
        user:       audit_context.user_id,
        action:     :update,
        object:     old_object.class,
        object_id:  old_object.id,
        old_object: old_object.to_json(except: %i[updated_at created_at]),
        new_object: new_object.to_json(except: %i[updated_at created_at])
      )
    rescue StandardError => e
      Bandiera.logger.error("Audit logging (#record_update_object) failed: #{e.message}")
    end

    def record_delete_object(audit_context, object)
      AuditRecord.create(
        user:       audit_context.user_id,
        action:     :delete,
        object:     object.class,
        object_id:  object.id,
        old_object: object.to_json(except: %i[updated_at created_at])
      )
    rescue StandardError => e
      Bandiera.logger.error("Audit logging (#record_delete_object) failed: #{e.message}")
    end

    private

    def format(params)
      params.to_json if params && !params.empty?
    end
  end
end
