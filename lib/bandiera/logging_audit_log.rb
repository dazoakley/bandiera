module Bandiera
  class LoggingAuditLog
    def initialize(db = Db.connect)
      @db = db
    end

    def record_add_object(audit_context, object)
      AuditRecord.create(
        user: audit_context.user_id,
        action: :create,
        object: object.class,
        object_id: object.id,
        new_object: object.to_json(except: [:updated_at, :created_at])
      )
    rescue => err
      Bandiera.logger.error("Audit logging (#record_add_object) failed: #{err.message}")
    end

    def record_update_object(audit_context, old_object, new_object)
      AuditRecord.create(
        user: audit_context.user_id,
        action: :update,
        object: old_object.class,
        object_id: old_object.id,
        old_object: old_object.to_json(except: [:updated_at, :created_at]),
        new_object: new_object.to_json(except: [:updated_at, :created_at])
      )
    rescue => err
      Bandiera.logger.error("Audit logging (#record_update_object) failed: #{err.message}")
    end

    def record_delete_object(audit_context, object)
      AuditRecord.create(
        user: audit_context.user_id,
        action: :delete,
        object: object.class,
        object_id: object.id,
        old_object: object.to_json(except: [:updated_at, :created_at])
      )
    rescue => err
      Bandiera.logger.error("Audit logging (#record_delete_object) failed: #{err.message}")
    end

    private

    def format(params)
      if params && !params.empty?
        params.to_json
      else
        nil
      end
    end

  end
end
